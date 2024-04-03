#!/usr/bin/env ruby

require_relative '../lib/parse_options.rb'
require_relative '../lib/edr_tester_ops.rb'
require 'logger'
require 'json'

begin
  opts = parse_options

  logger = Logger.new('edr_tester.log', progname: $PROGRAM_NAME)
  logger.formatter = proc do |severity, time, progname, hash|
    JSON.dump(
      severity: severity,
      timestamp: time,
      progname: progname,
      **hash
    ) + "\n"
  end

  case opts[:op]
    when :none
      logger.info('Did nothing')
    when :exec
      result = exec_file(opts[:file_path], opts[:args])
      logger.info({ operation: "Process Start" }.merge(result))
    else
      logger.debug("Unexpected operation. #{opts.to_json}")
  end

ensure
  logger.close
end
