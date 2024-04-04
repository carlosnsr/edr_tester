# getoptlong because I want POSIX guidelines compliant command-line options
require 'getoptlong'

USAGE = <<~EOF
  usage:
    edr_tester [--help | -h]
    edr_tester [--exec | -x] [--file, -f] <file path>
    edr_tester [--exec | -x] [--file, -f] <file path> -- <arguments>
    edr_tester [--create | -c] [--file, -f] <file path> [--bin | --text]
    edr_tester [--delete | -d] [--file, -f] <file path>
    edr_tester [--modify | -m] [--file, -f] <file path>
    edr_tester [--transmit | -t] [--dest] <address> [--port] <port> [--data] <data>

  operations:
    --help, -h      Displays this usage documentation
    --exec, -x      Executes the file at the given file path.
                    Any arguments after -- are passed to the file when it
                    is executed.
    --create, -c    Creates a file of the specified type (defaults to text)
    --delete, -d    Deletes the specified file
    --modify, -m    Modifies the specified file.
                    Detects if binary or text and appends some cruft
    --transmit, -t  Transmits the given data to the given address and port over TCP
                    Requires --dest, --port, and --data

  options:
    --file, -f      The file path to use
    --bin           Used for creating a binary file
    --text          Used for creating a text file
    --data          Specifies the IP address to connect to when
    --dest          Specifies the data to transmit
    --port          Specifies the port to connect to

  example:
    ./edr_tester --exec -f /bin/echo -- hello world
EOF

# destructively parses ARGV and returns a hash with the parameters for the given operation
#    e.g. { op: :exec, file_path: '/bin/echo', args: 'hello' }
# returns { op: :none } if an error occurred or no further action was required
def parse_options
  if ARGV.length == 0
    puts USAGE
    return { op: :none }
  end

  opts = GetoptLong.new(
    # main operators
    ['--help', '-h', GetoptLong::NO_ARGUMENT],
    ['--exec', '-x', GetoptLong::NO_ARGUMENT],
    ['--create', '-c', GetoptLong::NO_ARGUMENT],
    ['--delete', '-d', GetoptLong::NO_ARGUMENT],
    ['--modify', '-m', GetoptLong::NO_ARGUMENT],
    ['--transmit', '-t', GetoptLong::NO_ARGUMENT],
    # modifiers
    ['--file', '-f', GetoptLong::REQUIRED_ARGUMENT],
    ['--bin', GetoptLong::NO_ARGUMENT],
    ['--text', GetoptLong::NO_ARGUMENT],
    ['--data', GetoptLong::REQUIRED_ARGUMENT],
    ['--dest', GetoptLong::REQUIRED_ARGUMENT],
    ['--port', GetoptLong::REQUIRED_ARGUMENT],
  )
  opts.quiet = true # silences unwanted STDERR

  result = {}
  opts.each do |opt, arg|
    case opt
      when '--help'
        puts USAGE
        return { op: :none }
      when '--exec', '--delete', '--modify'
        result[:op] = opt[2..].to_sym
      when '--create'
        result[:op] = :create
        result[:file_type] = :text unless result[:file_type]
      when '--transmit'
        result[:op] = :transmit
      # modifiers
      when '--file'
        result[:file_path] = arg
      when '--bin'
        result[:file_type] = :binary
      when '--text'
        result[:file_type] = :text
      when '--data'
        result[:data] = arg
      when '--dest'
        result[:dest] = arg
      when '--port'
        result[:port] = arg.to_i
    end
  end

  # collect pass-along arguments
  if ARGV.length > 0
    args = ARGV.shift(ARGV.length).map(&:to_str)
    result[:args] = args
  end

  check = case result[:op]
    when :transmit
      check_transmit_options(result)
    when :exec, :create, :delete, :modify
      check_file_path_exists(result)
    else
      [:ok, :none]
  end

  return result if check[0] == :ok

  puts "option `--#{result[:op].to_s}' requires #{check[1]}"
  puts USAGE
  return { op: :none } # TODO: add error message in here

rescue GetoptLong::Error => error
  puts error.message
  puts USAGE
  return { op: :none } # TODO: add error message in here
end

def check_transmit_options(options)
  return [:error, 'a destination'] unless options[:dest]
  return [:error, 'data to transmit'] unless options[:data]
  return [:error, 'a port'] unless options[:port]
  [:ok, :none]
end

def check_file_path_exists(options)
  return [:error, 'a file path'] unless options[:file_path]
  [:ok, :none]
end
