# getoptlong because I want POSIX guidelines compliant command-line options
require 'getoptlong'

# TODO: change to using -f to accept file and make --exec (etc.) standalone
USAGE = <<~EOF
  usage:
    edr_tester [--help | -h]
    edr_tester [--exec | -x] <file path>
    edr_tester [--exec | -x] <file path> -- <arguments>
    edr_tester [--create | -c] <file path> [--bin | --text]
    edr_tester [--delete | -d] <file path>
    edr_tester [--modify | -m] <file path>
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
    --bin           Used for creating a binary file
    --text          Used for creating a text file
    --data          Specifies the IP address to connect to when using --transmit
    --dest          Specifies the data to transmit when using --transmit
    --port          Specifies the port to connect to when using --transmit
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
    ['--exec', '-x', GetoptLong::REQUIRED_ARGUMENT],
    ['--create', '-c', GetoptLong::REQUIRED_ARGUMENT],
    ['--delete', '-d', GetoptLong::REQUIRED_ARGUMENT],
    ['--modify', '-m', GetoptLong::REQUIRED_ARGUMENT],
    ['--transmit', '-t', GetoptLong::NO_ARGUMENT],
    # modifiers
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
      when '--exec'
        result = { op: :exec, file_path: arg }
        # collect pass-along arguments
        if ARGV.length > 0
          ARGV.shift # discards "--"
          args = ARGV.shift(ARGV.length).map(&:to_str)
          result[:args] = args
        end
        return result
      when '--create'
        result.merge!(op: :create, file_path: arg)
        result[:file_type] = :text unless result[:file_type]
      when '--delete'
        return { op: :delete, file_path: arg }
      when '--modify'
        return { op: :modify, file_path: arg }
      when '--transmit'
        result[:op] = :transmit
      # modifiers
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

  check = [:ok, :none]
  case result[:op]
    when :transmit
      check = check_transmit_options(result)
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
