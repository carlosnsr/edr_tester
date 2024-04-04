require 'spec_helper'
require 'timecop'
require 'fileutils'
require 'edr_tester_ops'

describe '.exec_file' do
  around do |example|
    Timecop.freeze(time)
    orig_user = ENV['USER']
    ENV['USER'] = user
    example.run
  ensure
    ENV['USER'] = orig_user
    Timecop.return
  end

  let(:user) { 'exec_tester' }
  let(:time) { Time.now }
  let(:pid) { 8724 }

  context 'when given a path to an executable file' do
    before { allow(Kernel).to receive(:spawn).with(cmd) { pid } }

    let(:file_path) { '/bin/echo' }
    let(:cmd) { file_path }

    it 'runs the given file' do
      expect(Kernel).to receive(:spawn).with(cmd)
      exec_file(file_path)
    end

    it 'returns the start time, cmd, and pid' do
      expect(exec_file(file_path)).to eq({
        start_time: time,
        process_command_line: cmd,
        spawned_process_id: pid
      })
    end
  end

  context 'when given a path to an executable file and arguments' do
    before { allow(Kernel).to receive(:spawn).with(cmd) { pid } }

    let(:file_path) { '/bin/echo' }
    let(:args) { ['hello', 'there'] }
    let(:cmd) { file_path + ' hello there'}

    it 'runs the given file' do
      expect(Kernel).to receive(:spawn).with(cmd)
      exec_file(file_path, args)
    end

    it 'returns the start time, cmd, and pid' do
      expect(exec_file(file_path, args)).to eq({
        start_time: time,
        process_command_line: cmd,
        spawned_process_id: pid
      })
    end
  end

  context 'when file path is incorrect' do
    let(:file_path) { './dont_exist' }
    let(:args) { ['hello', 'there'] }
    let(:cmd) { file_path + ' hello there'}

    it 'does not raise an error' do
      expect { exec_file(file_path) }.to_not raise_error
    end

    it 'does NOT run the given file' do
      expect(Kernel).to_not receive(:spawn).with(cmd)
      exec_file(file_path, args)
    end

    it 'returns the command line and error' do
      expect(exec_file(file_path, args)).to eq({
        process_command_line: cmd,
        error: "File '#{file_path}' does not exist"
      })
    end
  end
end

ROOT = './spec/tmp'

describe '.create_file' do
  before(:all) { FileUtils.mkdir(ROOT, mode: 0700) }
  after(:all) { FileUtils.rm_rf(ROOT) }

  after { FileUtils.rm(file_path) if File.exist?(file_path) }

  context 'given a file path and a file type of text' do
    let(:file_path) { "#{ROOT}/text_file" }
    let(:file_type) { :text }

    it 'creates a file at the specified location with the default text' do
      expect { create_file(file_path, file_type) }
        .to change { Dir.children(ROOT).count }.by(1)
      expect(File.readlines(file_path)).to eq([CONTENT])
    end

    it 'returns the file_path' do
      expect(create_file(file_path, file_type)).to eq({ file_path: file_path, })
    end
  end

  context 'given a file path and a file type of binary' do
    let(:file_path) { "#{ROOT}/binary_file" }
    let(:file_type) { :binary }

    it 'creates a file at the specified location with default binary data' do
      expect { create_file(file_path, file_type) }
        .to change { Dir.children(ROOT).count }.by(1)
      expect(File.readlines(file_path)).to eq([encode(CONTENT)])
    end

    it 'returns the file_path' do
      expect(create_file(file_path, file_type)).to eq({ file_path: file_path, })
    end
  end

  context 'when file path is to a location that does not exist' do
    let(:file_path) { './path/doesnt/exist/file.txt' }
    let(:file_type) { :text }

    it 'does not raise an error' do
      expect { create_file(file_path, file_type) }.to_not raise_error
    end

    it 'does NOT create the given file' do
      expect { create_file(file_path, file_type) }
        .to_not change { Dir.children(ROOT).count }
    end

    it 'returns the error' do
      expect(create_file(file_path, file_type)).to eq({
        error: "Path '#{File.dirname(file_path)}' does not exist"
      })
    end
  end
end

describe '.delete_file' do
  before(:all) { FileUtils.mkdir(ROOT, mode: 0700) }
  after(:all) { FileUtils.rm_rf(ROOT) }

  after { FileUtils.rm(file_path) if File.exist?(file_path) }

  context 'given a file path and the file exists' do
    before { FileUtils.touch(file_path) }

    let(:file_path) { "#{ROOT}/doomed_file" }

    it 'deletes a file at the specified location' do
      expect { delete_file(file_path) }
        .to change { Dir.children(ROOT).count }.by(-1)
    end

    it 'returns the file_path' do
      expect(delete_file(file_path)).to eq({ file_path: file_path, })
    end
  end

  context 'when file path is to a location that does not exist' do
    let(:file_path) { './path/doesnt/exist/file.txt' }

    it 'does not raise an error' do
      expect { delete_file(file_path) }.to_not raise_error
    end

    it 'does NOT delete the given file' do
      expect { delete_file(file_path) }
        .to_not change { Dir.children(ROOT).count }
    end

    it 'returns the error' do
      expect(delete_file(file_path)).to eq({
        error: "File '#{file_path}' does not exist"
      })
    end
  end
end

describe '.modify_file' do
  before(:all) { FileUtils.mkdir(ROOT, mode: 0700) }
  after(:all) { FileUtils.rm_rf(ROOT) }

  after { FileUtils.rm(file_path) if File.exist?(file_path) }

  context 'given a file path and a text file exists at that location' do
    before { create_file(file_path, :text) }

    let(:file_path) { "#{ROOT}/text_file" }

    it 'modifies the file adding an extra line of default text' do
      modify_file(file_path)
      expect(File.readlines(file_path)).to eq([CONTENT + CONTENT])
    end

    it 'returns the file_path' do
      expect(modify_file(file_path)).to eq({ file_path: file_path, })
    end
  end

  context 'given a file path and a binary file exists at that location' do
    before { create_file(file_path, :binary) }

    let(:file_path) { "#{ROOT}/binary_file" }

    it 'modifies the file adding an extra line of default text' do
      modify_file(file_path)
      expected = "\u0004\bI\"\u001FLorem ipsum dolor sit amet\u0006:\u0006ETLorem ipsum dolor sit amet"
      expect(File.readlines(file_path)).to eq([expected])
    end

    it 'returns the file_path' do
      expect(modify_file(file_path)).to eq({ file_path: file_path, })
    end
  end

  context 'when file path is to a location that does not exist' do
    let(:file_path) { './path/doesnt/exist/file.txt' }

    it 'does not raise an error' do
      expect { modify_file(file_path) }.to_not raise_error
    end

    it 'does NOT modify the given file' do
      expect { modify_file(file_path) }
        .to_not change { Dir.children(ROOT).count }
    end

    it 'returns the error' do
      expect(modify_file(file_path)).to eq({
        error: "File '#{file_path}' does not exist"
      })
    end
  end
end

describe '.transmit_data' do
  let(:socket) { instance_double('TCPSocket') }
  let(:dest) { 'localhost' }
  let(:port) { 8888 }
  let(:data) { 'I just called/to say/I love you' }
  let(:addr) { ["AF_INET", 56158, "localhost", "127.0.0.1"] }

  context 'when connection succeeds' do
    before do
      allow(TCPSocket).to receive(:open).with(dest, port) { socket }
      allow(socket).to receive(:close)
      allow(socket).to receive(:write).with(data) { data.length }
      allow(socket).to receive(:addr).with(true) { addr }
    end

    it 'connects to a TCP socket' do
      expect(TCPSocket).to receive(:open)
      transmit_data(dest, port, data)
    end

    it 'transmits data' do
      expect(socket).to receive(:write).with(data)
      transmit_data(dest, port, data)
    end

    it 'returns address and port for the destination and source, protocol, and amount sent' do
      expect(transmit_data(dest, port, data)).to eql({
        destination_address: dest,
        destination_port: port,
        source_address: addr[3],
        source_port: addr[1],
        amount_of_data_sent: data.length,
        protocol: 'TCP',
      })
    end
  end
end
