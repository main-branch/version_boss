# frozen_string_literal: true

require 'tmpdir'

RSpec.describe Semverify::CommandLine do
  around do |example|
    Dir.mktmpdir do |dir|
      Dir.chdir(dir) do
        example.run
      end
    end
  end

  context 'file' do
    subject { described_class.start(['file', *args]) }

    let(:args) { [] }

    context 'when a version file could not be found' do
      it 'should exit with exitstatus 1 and an error to stderr' do
        expect { subject }.to exit_with(1, "version file not found or is not valid\n")
      end

      context 'with the -q option' do
        let(:args) { %w[-q] }

        it 'should exit with exitstatus 1 and no error to stderr' do
          expect { subject }.to exit_with(1, '')
        end
      end
    end

    context 'with a valid version file' do
      let(:expected_version) { '1.2.3.pre.1' }

      before do
        File.write('VERSION', expected_version)
      end

      it 'should output the current version file path to stdout' do
        expect { subject }.to output("VERSION\n").to_stdout
      end

      context 'with the -q option' do
        let(:args) { %w[-q] }

        it 'should output nothing to stdout' do
          expect { subject }.to output('').to_stdout
        end
      end
    end
  end
end
