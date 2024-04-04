#!/usr/bin/env ruby

require_relative '../lib/parse_options.rb'
require_relative '../lib/edr_tester_ops.rb'
require 'logger'
require 'json'

begin
  opts = parse_options

  user = ENV['USER'] || ENV['USERNAME']
  # set up the logger to output JSON
  logger = Logger.new('edr_tester.log', progname: $PROGRAM_NAME)
  logger.formatter = proc do |severity, time, progname, hash|
    JSON.dump(
      severity: severity,
      timestamp: time,
      username: user,
      process_name: progname,
      process_id: Process.pid,
      **hash
    ) + "\n"
  end

  case opts[:op]
    when :none
      logger.info('Did nothing')
    when :exec
      result = exec_file(opts[:file_path], opts[:args])
      logger.info({ activity_descriptor: "Process Start" }.merge!(result))
    when :create
      result = create_file(opts[:file_path], opts[:file_type])
      logger.info({ activity_descriptor: "Create File" }.merge!(result))
    when :delete
      result = delete_file(opts[:file_path])
      logger.info({ activity_descriptor: "Delete File" }.merge!(result))
    else
      logger.error({ error: "Unexpected Operation" }.merge(opts))
  end

ensure
  logger.close
end
