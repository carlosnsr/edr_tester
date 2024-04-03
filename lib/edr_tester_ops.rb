# Danger of command injection
# Should not be called with unknown or unsanitised commands
def exec_file(file_path, args = [])
  user = ENV['USER'] || ENV['USERNAME']
  cmd = "#{file_path}"
  start_time = Time.now
  pid = Kernel.spawn(cmd)

  [start_time, user, cmd, pid]
end
