# Given a file_path and optional arguments
# Spawns a process executingc that file with the given arguments
# Returns the start_time, user, command executed, and process ID
# NOTE: Danger of command injection
#       Should not be called with unknown or unsanitised commands
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

CONTENT = 'Lorem ipsum dolor sit amet'

# Given a file_path and file type (supported: :binary, :text)
# Creates a file of the specified type at the specified location
# TODO: Returns the start_time, user, command executed, and process ID
def create_file(file_path, file_type)
  File.open(file_path, 'w') do |f|
    f.write(TEXT_CONTENT)
  end
end
