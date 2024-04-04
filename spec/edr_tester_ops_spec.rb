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

describe '.create_file' do
  ROOT = './spec/tmp'

  around do |example|
    FileUtils.mkdir(ROOT, mode: 0700)
    example.run
  ensure
    FileUtils.rm_rf(ROOT)
  end

  context 'given a file path and a file type of text' do
    let(:file_path) { "#{ROOT}/text_file" }
    let(:file_type) { :text }

    it 'creates a file at the specified location with the default text' do
      expect { create_file(file_path, file_type) }
        .to change { Dir.children(ROOT).count }.by(1)
      expect(File.readlines(file_path)).to eq([CONTENT])
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
  end
end
