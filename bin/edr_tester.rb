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
      logger.info({ activity_descriptor: "PROCESS_START" }.merge!(result))
    when :create
      result = create_file(opts[:file_path], opts[:file_type])
      logger.info({ activity_descriptor: "CREATE_FILE" }.merge!(result))
    when :delete
      result = delete_file(opts[:file_path])
      logger.info({ activity_descriptor: "DELETE_FILE" }.merge!(result))
    when :modify
      result = modify_file(opts[:file_path])
      logger.info({ activity_descriptor: "MODIFY_FILE" }.merge!(result))
    when :transmit
      result = transmit_data(opts[:dest], opts[:port], opts[:data])
      logger.info({ activity_descriptor: "TRANSMIT_DATA" }.merge!(result))
    else
      logger.error({ error: "Unexpected Operation" }.merge(opts))
  end

ensure
  logger.close
end
