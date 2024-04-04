require 'spec_helper'
require 'parse_options'

describe '.parse_options' do
  before(:each) { stub_const('ARGV', argv) }

  def suppress_stdout
    allow(STDOUT).to receive(:puts)
    yield
  end

  context 'when given a file path with Windows separators' do
    let(:windows_file_path) { '\bin\echo' }
    let(:file_path) { '/bin/echo' }
    let (:argv) { ['--file', windows_file_path] }

    it 'returns a mac-formatted file_path' do
      expect(parse_options).to eql({ file_path: file_path })
    end
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

  describe '--exec option' do
    context 'without a file path' do
      let (:argv) { ['--exec'] }

      it 'displays the error message and the usage text' do
        message = "option `#{argv[0]}' requires a file path"
        expect { parse_options }.to output("#{message}\n#{USAGE}").to_stdout
      end

      it 'returns :none' do
        suppress_stdout { expect(parse_options).to eql(op: :none) }
      end
    end

    context 'with a file path' do
      let (:file_path) { '/bin/echo' }
      let (:argv) { ['--exec', '--file', file_path] }

      it 'returns :exec and file path' do
        expect(parse_options).to eql({ op: :exec, file_path: file_path })
      end
    end

    context 'with a file path and pass-along arguments' do
      let (:file_path) { '/usr/bin/echo' }
      let (:additional_args) { ["hello", "all", "my", "peeps"] }
      let (:argv) { ['--exec', '--file', file_path, "--"].concat(additional_args) }

      it 'returns :exec, file path and pass-along arguments' do
        expect(parse_options).to eql({
          op: :exec,
          file_path: file_path,
          args: additional_args
        })
      end
    end
  end

  describe '--create option' do
    context 'without a file path' do
      let (:argv) { ['--create'] }

      it 'displays the error message and the usage text' do
        message = "option `#{argv[0]}' requires a file path"
        expect { parse_options }.to output("#{message}\n#{USAGE}").to_stdout
      end

      it 'returns :none' do
        suppress_stdout { expect(parse_options).to eql(op: :none) }
      end
    end

    context 'with a file path' do
      let (:file_path) { './tmp/new_file' }
      let (:argv) { ['--create', '--file', file_path] }

      it 'returns :create, file path, and default type' do
        expect(parse_options).to eql(op: :create, file_path: file_path, file_type: :text)
      end
    end

    context 'with a file path and type' do
      let (:file_path) { './tmp/new_file' }
      let (:argv) { ['--create', '--file', file_path, '--bin'] }

      it 'returns :create, file path, and default type' do
        expect(parse_options).to eql(op: :create, file_path: file_path, file_type: :binary)
      end
    end
  end

  describe '--delete option' do
    context 'without a file path' do
      let (:argv) { ['--delete'] }

      it 'displays the error message and the usage text' do
        message = "option `#{argv[0]}' requires a file path"
        expect { parse_options }.to output("#{message}\n#{USAGE}").to_stdout
      end

      it 'returns :none' do
        suppress_stdout { expect(parse_options).to eql(op: :none) }
      end
    end

    context 'with a file path' do
      let (:file_path) { './tmp/new_file' }
      let (:argv) { ['--delete', '--file', file_path] }

      it 'returns :delete and file path' do
        expect(parse_options).to eql(op: :delete, file_path: file_path)
      end
    end

    context 'with a file path and type' do
      let (:file_path) { './tmp/new_file' }
      let (:argv) { ['--delete', '--file', file_path] }

      it 'returns :delete and file path' do
        expect(parse_options).to eql(op: :delete, file_path: file_path)
      end
    end
  end

  describe '--modify option' do
    context 'without a file path' do
      let (:argv) { ['--modify'] }

      it 'displays the error message and the usage text' do
        message = "option `#{argv[0]}' requires a file path"
        expect { parse_options }.to output("#{message}\n#{USAGE}").to_stdout
      end

      it 'returns :none' do
        suppress_stdout { expect(parse_options).to eql(op: :none) }
      end
    end

    context 'with a file path' do
      let (:file_path) { './tmp/new_file' }
      let (:argv) { ['--modify', '--file', file_path] }

      it 'returns :modify and file path' do
        expect(parse_options).to eql(op: :modify, file_path: file_path)
      end
    end

    context 'with a file path and type' do
      let (:file_path) { './tmp/new_file' }
      let (:argv) { ['--modify', '--file', file_path] }

      it 'returns :modify and file path' do
        expect(parse_options).to eql(op: :modify, file_path: file_path)
      end
    end
  end

  describe '--transmit option' do
    let(:dest) { 'localhost' }
    let(:port) { 2000 }
    let(:data) { 'I just called/to say/I love you' }

    context 'without a dest' do
      let (:argv) { ['--transmit', '--port', port, '--data', data] }

      it 'displays the error message and the usage text' do
        message = "option `#{argv[0]}' requires a destination"
        expect { parse_options }.to output("#{message}\n#{USAGE}").to_stdout
      end

      it 'returns :none' do
        suppress_stdout { expect(parse_options).to eql(op: :none) }
      end
    end

    context 'without a dest' do
      let (:argv) { ['--transmit', '--dest', dest, '--data', data] }

      it 'displays the error message and the usage text' do
        message = "option `#{argv[0]}' requires a port"
        expect { parse_options }.to output("#{message}\n#{USAGE}").to_stdout
      end

      it 'returns :none' do
        suppress_stdout { expect(parse_options).to eql(op: :none) }
      end
    end

    context 'without data' do
      let (:argv) { ['--transmit', '--dest', dest, '--port', port] }

      it 'displays the error message and the usage text' do
        message = "option `#{argv[0]}' requires data to transmit"
        expect { parse_options }.to output("#{message}\n#{USAGE}").to_stdout
      end

      it 'returns :none' do
        suppress_stdout { expect(parse_options).to eql(op: :none) }
      end
    end

    context 'with a dest, port, and data' do
      let (:argv) { ['--transmit', '--dest', dest, '--port', port, '--data', data] }

      it 'returns :transmit, dest, port, and data ' do
        expect(parse_options).to eql(
          op: :transmit,
          dest: dest,
          port: port,
          data: data
        )
      end
    end
  end
end
