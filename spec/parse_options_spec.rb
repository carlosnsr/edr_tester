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

    it 'returns :none' do
      suppress_stdout { expect(parse_options).to eql(op: :none) }
    end
  end

  context 'when receiving no options' do
    let (:argv) { [] }

    it 'displays the usage text' do
      expect { parse_options }.to output(USAGE).to_stdout
    end

    it 'returns :none' do
      suppress_stdout { expect(parse_options).to eql(op: :none) }
    end
  end

  context 'when receiving an invalid option' do
    let (:argv) { ['--invalid'] }

    it 'displays the error message and the usage text' do
      message = "unrecognized option `#{argv[0]}'"
      expect { parse_options }.to output("#{message}\n#{USAGE}").to_stdout
    end

    it 'returns :none' do
      suppress_stdout { expect(parse_options).to eql(op: :none) }
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

        it 'returns :none' do
          suppress_stdout { expect(parse_options).to eql(op: :none) }
        end
      end
    end
  end

  context 'when receiving the exec option without a file path' do
    let (:argv) { ['--exec'] }

    it 'displays the error message and the usage text' do
      message = "option `#{argv[0]}' requires an argument"
      expect { parse_options }.to output("#{message}\n#{USAGE}").to_stdout
    end

    it 'returns :none' do
      suppress_stdout { expect(parse_options).to eql(op: :none) }
    end
  end

  context 'when receiving the exec option with a file path' do
    let (:file_path) { '/bin/echo' }
    let (:argv) { ['--exec', file_path] }

    it 'returns :exec and file path' do
      expect(parse_options).to eql({ op: :exec, file_path: file_path })
    end
  end

  context 'when receiving the exec option with a file path and pass-along arguments' do
    let (:file_path) { '/usr/bin/echo' }
    let (:additional_args) { ["hello", "all", "my", "peeps"] }
    let (:argv) { ['--exec', file_path, "--"].concat(additional_args) }

    it 'returns :exec, file path and pass-along arguments' do
      expect(parse_options).to eql({
        op: :exec,
        file_path: file_path,
        args: additional_args
      })
    end
  end

  context 'when receiving the create option without a file path' do
    let (:argv) { ['--create'] }

    it 'displays the error message and the usage text' do
      message = "option `#{argv[0]}' requires an argument"
      expect { parse_options }.to output("#{message}\n#{USAGE}").to_stdout
    end

    it 'returns :none' do
      suppress_stdout { expect(parse_options).to eql(op: :none) }
    end
  end

  context 'when receiving the create option with a file path' do
    let (:file_path) { './tmp/new_file' }
    let (:argv) { ['--create', file_path] }

    it 'returns :create, file path, and default type' do
      expect(parse_options).to eql(op: :create, file_path: file_path, file_type: :text)
    end
  end

  context 'when receiving the create option with a file path and type' do
    let (:file_path) { './tmp/new_file' }
    let (:argv) { ['--create', file_path, '--bin'] }

    it 'returns :create, file path, and default type' do
      expect(parse_options).to eql(op: :create, file_path: file_path, file_type: :binary)
    end
  end
end
