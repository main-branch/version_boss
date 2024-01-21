# frozen_string_literal: true

require 'tmpdir'

RSpec.describe Semverify::CommandLine do
  from_version = '1.2.3.beta.4'

  context '#next_pre' do
    subject { described_class.start(['next-pre', *args]) }

    let(:args) { [] }

    around do |example|
      Dir.mktmpdir do |dir|
        Dir.chdir(dir) do
          example.run
        end
      end
    end

    context 'when given an invalid VERSION' do
      let(:version) { 'invalid' }
      let(:args) { [version] }
      it 'should exit with exitstatus 1 and an error to stderr' do
        expect { subject }.to exit_with(1, "Not a valid version string: invalid\n")
      end
    end

    context 'when given extra args' do
      let(:args) { [from_version, 'extra'] }
      it 'should exit with exitstatus 1, report the error, and show usage' do
        expect { subject }.to exit_with(1, /^ERROR: .*\nUsage: /)
      end
    end

    context 'when given an invalid option' do
      let(:args) { [from_version, '--invalid'] }
      it 'should exit with exitstatus 1, report the error, and show usage' do
        expect { subject }.to exit_with(1, /^ERROR: .*\nUsage: /)
      end
    end

    # context "when given VERSION is #{from_version}+AMD64" do
    #   let(:version) { "#{from_version}+AMD64" }

    #   context 'when --build is not given' do
    #     let(:args) { [version] }
    #     it 'should output 1.2.3-beta.5+AMD64 (preserve the build metadata)' do
    #       expect { subject }.to output("1.2.3-beta.5+AMD64\n").to_stdout
    #     end
    #   end

    #   context 'when --build="" is given' do
    #     let(:args) { [version, '--build='] }
    #     it 'should output 1.2.3-beta.5 (clear the build metadata)' do
    #       expect { subject }.to output("1.2.3-beta.5\n").to_stdout
    #     end
    #   end

    #   context 'when --build=368 is given' do
    #     let(:args) { [version, '--build=386'] }
    #     it 'should output 1.2.3-beta.5+386 (replace the build metadata)' do
    #       expect { subject }.to output("1.2.3-beta.5+386\n").to_stdout
    #     end
    #   end
    # end

    context "when given VERSION is #{from_version}" do
      let(:version) { from_version }
      let(:args) { [version] }

      context 'when not other args are given' do
        it "should output '1.2.3.beta.5' (clear the pre-release)" do
          expect { subject }.to output("1.2.3.beta.5\n").to_stdout
        end
      end

      context 'when --pre-type=alpha is given' do
        let(:args) { [version, '--pre-type=alpha'] }

        it 'should exit with exitstatus 1, report the error, and show usage' do
          expect { subject }.to exit_with(1, /^Cannot increment the pre-release identifier/)
        end
      end

      context 'when --pre-type=beta is given' do
        let(:args) { [version, '--pre-type=beta'] }

        it "should output '1.2.3.beta.5' (clear the pre-release)" do
          expect { subject }.to output("1.2.3.beta.5\n").to_stdout
        end
      end

      context 'when --pre-type=rc is given' do
        let(:args) { [version, '--pre-type=rc'] }

        it "should output '1.2.3.rc.1' (clear the pre-release)" do
          expect { subject }.to output("1.2.3.rc.1\n").to_stdout
        end
      end

      context 'when --dry-run is given' do
        it "should output '1.2.3.beta.5' (clear the pre-release)" do
          expect { subject }.to output("1.2.3.beta.5\n").to_stdout
        end
      end

      context 'when --quiet is given' do
        let(:args) { [version, '--quiet'] }

        it 'should output nothing' do
          expect { subject }.to output('').to_stdout
        end
      end
    end

    context 'when VERSION is not given' do
      let(:args) { [] }

      context 'when a version file could not be found' do
        it 'should exit with exitstatus 1 and report the error' do
          expect { subject }.to exit_with(1, "version file not found or is not valid\n")
        end
      end

      context "when the version file contains the version #{from_version}" do
        before { File.write('VERSION', from_version) }

        it 'should output 1.2.3.beta.5 and update the version in the version file to 1.2.3.beta.5' do
          expect { subject }.to output("1.2.3.beta.5\n").to_stdout
          expect(File.read('VERSION')).to eq('1.2.3.beta.5')
        end
      end

      context "when given --dry-run and the version file contains the version #{from_version}" do
        let(:args) { ['--dry-run'] }

        before { File.write('VERSION', from_version) }

        it 'should output 1.2.3.beta.5 and leave the version in the version file alone' do
          expect { subject }.to output("1.2.3.beta.5\n").to_stdout
          expect(File.read('VERSION')).to eq(from_version)
        end
      end
    end
  end
end
