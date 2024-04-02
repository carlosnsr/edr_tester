require 'spec_helper'
require 'parse_options'

describe '.parse_options' do
  before(:each) { stub_const('ARGV', argv) }

  def suppress_out
    allow(STDOUT).to receive(:puts)
    yield
  end

  context 'when receiving the help option' do
    let (:argv) { ['--help'] }

    it 'displays the usage text' do
      expect { parse_options }.to output(USAGE).to_stdout
    end

    it 'returns :help' do
      suppress_out { expect(parse_options).to eql(:help) }
    end
  end

  context 'when receiving no options' do
    let (:argv) { [] }

    it 'displays the usage text' do
      expect { parse_options }.to output(USAGE).to_stdout
    end

    it 'returns :none' do
      suppress_out { expect(parse_options).to eql(:none) }
    end
  end

  context 'when receiving an invalid option' do
    let (:argv) { ['--invalid'] }

    it 'displays the usage text' do
      expect { parse_options }
        .to output("unrecognized option `#{argv[0]}'\n#{USAGE}").to_stdout
    end

    it 'returns :invalid' do
      suppress_out { expect(parse_options).to eql(:invalid) }
    end
  end
end
