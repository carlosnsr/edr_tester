# Danger of command injection
# Should not be called with unknown or unsanitised commands
def exec_file(file_path, args = [])
  user = ENV['USER'] || ENV['USERNAME']
  cmd = "#{file_path}" + (args.empty? ? "" : " #{args.join(' ')}")

  if !File.exist?(file_path)
    return {
      username: user,  # in case it's a permissions problem
      process_command_line: cmd,
      error: "File '#{file_path}' does not exist"
    }
  end

  start_time = Time.now
  pid = Kernel.spawn(cmd)

  {
    start_time: start_time,
    username: user,
    process_command_line: cmd,
    process_id: pid
  }
end
