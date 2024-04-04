require 'ptools'
require 'socket'

# Given a file_path and optional arguments
# Spawns a process executingc that file with the given arguments
# Returns the start_time, user, command executed, and process ID
# NOTE: Danger of command injection
#       Should not be called with unknown or unsanitised commands
def exec_file(file_path, args = [])
  cmd = "#{file_path}" + (args.empty? ? "" : " #{args.join(' ')}")

  if !File.exist?(file_path)
    return {
      process_command_line: cmd,
      error: "File '#{file_path}' does not exist"
    }
  end

  start_time = Time.now
  pid = Kernel.spawn(cmd)

  {
    start_time: start_time,
    process_command_line: cmd,
    spawned_process_id: pid
  }
end

CONTENT = 'Lorem ipsum dolor sit amet'

# Given a file_path and file type (supported: :binary, :text)
# Creates a file of the specified type at the specified location
# Returns the file_path
def create_file(file_path, file_type = :text)
  dirname = File.dirname(file_path)
  return { error: "Path '#{dirname}' does not exist" } if !Dir.exist?(dirname)

  flag = file_type == :binary ? 'wb' : 'w'
  case file_type
    when :text
      File.open(file_path, 'w') do |f|
        f.write(CONTENT)
      end
    when :binary
      File.open(file_path, 'wb') do |f|
        f.write(encode(CONTENT))
      end
    else
      raise RuntimeError, "unknown file type #{file_type}"
  end

  { file_path: file_path }
end

# Returns a binary representation of the given string
def encode(string)
  Marshal.dump(string)
end

# Given a file_path, deletes the file at the specified location
# Returns the file_path
def delete_file(file_path)
  return { error: "File '#{file_path}' does not exist" } if !File.exist?(file_path)

  File.delete(file_path)
  { file_path: file_path }
end

# Given a file_path, modifies the file with a line of 'content' on the end
# Returns the file_path
def modify_file(file_path)
  return { error: "File '#{file_path}' does not exist" } if !File.exist?(file_path)

  if File.binary?(file_path)
    File.open(file_path, 'ab') do |f|
      f.write(encode(CONTENT))
    end
  else
    File.open(file_path, 'a') do |f|
      f.write(CONTENT)
    end
  end

  { file_path: file_path }
end

def transmit_data(dest, port, data)
  socket = nil
  begin
    socket = TCPSocket.open(dest, port)
    sent = socket.write(data)
    source = socket.addr(true)
  ensure
    socket.close if socket
  end

  {
    destination_address: dest,
    destination_port: port,
    source_address: source[3],
    source_port: source[1],
    amount_of_data_sent: sent,
    protocol: 'TCP',
  }
end
