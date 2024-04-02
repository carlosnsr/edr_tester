require 'spec_helper'
require 'parse_options'

describe '.parse_options' do
  before(:each) { stub_const('ARGV', argv) }

  context 'when receiving the help option' do
    let (:argv) { ['--help'] }

    it 'displays the usage text' do
      expect { parse_options }.to output(USAGE).to_stdout
    end
  end

  context 'when receiving no options' do
    let (:argv) { [] }

    it 'displays the usage text' do
      expect { parse_options }.to output(USAGE).to_stdout
    end
  end
end
