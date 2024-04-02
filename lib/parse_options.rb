# getoptlong because I want POSIX guidelines compliant command-line options
require 'getoptlong'

USAGE = <<~EOF
  usage:
    edr_tester [--help | -h]
    edr_tester [[--exec | -x] <file path>]
    edr_tester [[--exec | -x] <file path> -- <arguments>]

  options:
    --help, -h    Displays this usage documentation
    --exec, -x    Executes the file at the given file path.
                  Any arguments after -- are passed to the file when it
                  is executed.
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
    ['--help', '-h', GetoptLong::NO_ARGUMENT],
    ['--exec', '-x', GetoptLong::REQUIRED_ARGUMENT],
  )
  opts.quiet = true # silences unwanted STDERR

  opts.each do |opt, arg|
    case opt
      when '--help'
        puts USAGE
        return { op: :none }
      when '--exec'
        result = { op: :exec, file_path: arg.to_s }
        # collect pass-along arguments
        if ARGV.length > 0
          ARGV.shift # discards "--"
          args = ARGV.shift(ARGV.length).map(&:to_str)
          result[:args] = args
        end
        return result
    end
  end

rescue GetoptLong::Error => error
  puts error.message
  puts USAGE
  return { op: :none }
end
