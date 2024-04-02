require 'spec_helper'
require 'parse_options'

describe '.parse_options' do
  before(:each) { stub_const('ARGV', argv) }

  def suppress_stdout
    allow(STDOUT).to receive(:puts)
    yield
  end

  context 'when receiving the help option' do
    let (:argv) { ['--help'] }

    it 'displays the usage text' do
      expect { parse_options }.to output(USAGE).to_stdout
    end

    it 'returns :help' do
      suppress_stdout { expect(parse_options).to eql(:help) }
    end
  end

  context 'when receiving no options' do
    let (:argv) { [] }

    it 'displays the usage text' do
      expect { parse_options }.to output(USAGE).to_stdout
    end

    it 'returns :none' do
      suppress_stdout { expect(parse_options).to eql(:none) }
    end
  end

  context 'when receiving an invalid option' do
    let (:argv) { ['--invalid'] }

    it 'displays the error message and the usage text' do
      expect { parse_options }
        .to output("unrecognized option `#{argv[0]}'\n#{USAGE}").to_stdout
    end

    it 'returns :invalid' do
      suppress_stdout { expect(parse_options).to eql(:invalid) }
    end
  end

  context 'when throwing any of the other silenced errors' do
    errors = [
      [GetoptLong::AmbiguousOption, "ambiguous option error"],
      [GetoptLong::MissingArgument, "missing argument error"],
      [GetoptLong::NeedlessArgument, "needless argument error"]
    ]

    errors.each do |args|
      error_class, message = args

      context "when throwing a #{error_class} error" do
        let (:argv) { ['--invalid'] }

        it 'displays the error message and the usage text' do
          allow(GetoptLong).to receive(:new).and_raise(error_class.new(message))
          expect { parse_options }
            .to output("#{message}\n#{USAGE}").to_stdout
        end

        it 'returns :invalid' do
          suppress_stdout { expect(parse_options).to eql(:invalid) }
        end
      end
    end
  end
end
