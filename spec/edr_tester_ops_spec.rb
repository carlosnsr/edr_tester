require 'spec_helper'
require 'timecop'
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

  before do
    allow(Kernel).to receive(:spawn).with(cmd) { pid }
  end

  let(:user) { 'exec_tester' }
  let(:time) { Time.now }
  let(:pid) { 8724 }

  context 'when given a path to an executable file' do
    let(:file_path) { '/bin/echo' }
    let(:cmd) { file_path }

    it 'runs the given file' do
      expect(Kernel).to receive(:spawn).with(cmd)
      exec_file(file_path)
    end

    it 'returns the start time, user, cmd, and pid' do
      expect(exec_file(file_path)).to eq([time, user, cmd, pid])
    end
  end

  context 'when given a path to an executable file and arguments' do
    let(:file_path) { '/bin/echo' }
    let(:args) { ['hello', 'there'] }
    let(:cmd) { file_path + ' hello there'}

    it 'runs the given file' do
      expect(Kernel).to receive(:spawn).with(cmd)
      exec_file(file_path, args)
    end

    it 'returns the start time, user, cmd, and pid' do
      expect(exec_file(file_path, args)).to eq([time, user, cmd, pid])
    end
  end

  context 'when file path is incorrect' do
  end

  context 'when given a path to a non-executable file' do
  end
end
