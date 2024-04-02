# getoptlong because I want POSIX guidelines compliant command-line options
require 'getoptlong'  

USAGE = <<~EOF
  usage:
    edr_tester [-h | --help]

  options:
    -h, --help    Displays this usage documentation
EOF

def parse_options
  if ARGV.length == 0
    puts USAGE
    return :none
  end

  opts = GetoptLong.new(
    ['--help', '-h', GetoptLong::NO_ARGUMENT],
  )
  opts.quiet = true # suppresses unwanted STDERR

  opts.each do |opt, arg|
    case opt
      when '--help'
        puts USAGE
        return :help
    end
  end

rescue GetoptLong::InvalidOption => error
  puts error.message
  puts USAGE
  return :invalid
end
