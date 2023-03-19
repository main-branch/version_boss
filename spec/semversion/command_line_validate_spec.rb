# frozen_string_literal: true

require 'tmpdir'

RSpec.describe Semverify::CommandLine do
  context 'validate' do
    subject { described_class.start(['validate', *args]) }

    let(:args) { [] }
    let(:expected_version) { '1.2.3-pre.1+build.999' }

    context 'when VERSION is not given' do
      it 'should exit with exitstatus 1 and an error to stderr' do
        expect { subject }.to exit_with(1, /^ERROR: "rspec validate" was called with no arguments\nUsage: /)
      end
    end

    context 'with an invalid VERSION' do
      let(:args) { %w[invalid] }
      it 'should exit with exitstatus 1 and an error to stderr' do
        expect { subject }.to exit_with(1, "Not a valid version string: invalid\n")
      end

      context 'with the -q option' do
        let(:args) { %w[invalid -q] }
        it 'should exit with exitstatus 1 and output nothing to stderr' do
          expect { subject }.to exit_with(1, '')
        end
      end
    end

    context 'with a valid VERSION, 1.2.3' do
      let(:args) { %w[1.2.3] }
      it "should output '1.2.3' to stdout" do
        expect { subject }.to output("1.2.3\n").to_stdout
      end

      context 'with the -q option' do
        let(:args) { %w[1.2.3 -q] }
        it 'should output nothing to stdout' do
          expect { subject }.to output('').to_stdout
        end
      end
    end

    # context 'with a valid version file' do
    #   before do
    #     File.write('VERSION', expected_version)
    #   end

    #   it 'should output the current version to stdout' do
    #     expect { subject }.to output("#{expected_version}\n").to_stdout
    #   end

    #   context 'with the -q option' do
    #     let(:args) { %w[-q] }

    #     it 'should output nothing to stdout' do
    #       expect { subject }.to output('').to_stdout
    #     end
    #   end
    # end
  end
end
