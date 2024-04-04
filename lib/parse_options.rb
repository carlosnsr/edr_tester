# getoptlong because I want POSIX guidelines compliant command-line options
require 'getoptlong'

USAGE = <<~EOF
  usage:
    edr_tester [--help | -h]
    edr_tester [--exec | -x] <file path>
    edr_tester [--exec | -x] <file path> -- <arguments>
    edr_tester [--create | -c] <file path> [--bin | --text]
    edr_tester [--delete | -d] <file path>

  operations:
    --help, -h    Displays this usage documentation
    --exec, -x    Executes the file at the given file path.
                  Any arguments after -- are passed to the file when it
                  is executed.
    --create, -c  Creates a file of the specified type (defaults to text)
    --delete, -d  Deletes the specified file

  options:
    --bin         Used for creating a binary file
    --text        Used for creating a text file

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
    # optionals
    ['--bin', GetoptLong::NO_ARGUMENT],
    ['--text', GetoptLong::NO_ARGUMENT],
  )
  opts.quiet = true # silences unwanted STDERR

  result = { file_type: :text }
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
      when '--delete'
        return { op: :delete, file_path: arg }
      when '--bin'
        result[:file_type] = :binary
      when '--text'
        result[:file_type] = :text
    end
  end

  result
rescue GetoptLong::Error => error
  puts error.message
  puts USAGE
  return { op: :none } # TODO: add error message in here
end
