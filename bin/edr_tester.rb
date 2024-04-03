#!/usr/bin/env ruby

require_relative '../lib/parse_options.rb'
require_relative '../lib/edr_tester_ops.rb'

opts = parse_options

case opts[:op]
  when :none
    # do nothing
  when :exec
    result = exec_file(opts[:file_path], opts[:args])
    puts result.inspect
  else
    puts "Unexpected operation"
    puts opts.inspect
end
