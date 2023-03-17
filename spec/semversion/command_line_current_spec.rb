# frozen_string_literal: true

require 'tmpdir'

RSpec.describe Semversion::CommandLine do
  around do |example|
    Dir.mktmpdir do |dir|
      Dir.chdir(dir) do
        example.run
      end
    end
  end

  context 'current' do
    subject { described_class.start(['current', *args]) }

    let(:args) { [] }
    let(:expected_version) { '1.2.3-pre.1+build.999' }

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
      before do
        File.write('VERSION', expected_version)
      end

      it 'should output the current version to stdout' do
        expect { subject }.to output("#{expected_version}\n").to_stdout
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
