# frozen_string_literal: true

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

RSpec::Matchers.define :exit_with do |expected_status, expected_stderr|
  match do |actual|
    begin
      expect do
        exitstatus = 0
        begin
          actual.call
        rescue SystemExit => e
          exitstatus = e.status
        end
        expect(exitstatus).to eq(expected_status)
      end.to output(expected_stderr).to_stderr
    rescue RSpec::Expectations::ExpectationNotMetError => e
      @failure_message = e.message
    end
    @failure_message.nil?
  end

  attr_reader :failure_message

  supports_block_expectations
end

RSpec.shared_examples 'Core Version Incrementer' do |part, from_version, to_version|
  command = "next-#{part}"
  subject { described_class.start([command, *args]) }

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

  context "when given VERSION is #{from_version}+AMD64" do
    let(:version) { "#{from_version}+AMD64" }

    context 'when --build is not given' do
      let(:args) { [version] }
      it "should output #{to_version}+AMD64 (preserve the build metadata)" do
        expect { subject }.to output("#{to_version}+AMD64\n").to_stdout
      end
    end

    context 'when --build="" is given' do
      let(:args) { [version, '--build='] }
      it "should output #{to_version} (clear the build metadata)" do
        expect { subject }.to output("#{to_version}\n").to_stdout
      end
    end

    context 'when --build=368 is given' do
      let(:args) { [version, '--build=386'] }
      it "should output #{to_version}+386 (replace the build metadata)" do
        expect { subject }.to output("#{to_version}+386\n").to_stdout
      end
    end
  end

  context "when given VERSION is #{from_version}-beta.4" do
    let(:version) { "#{from_version}-beta.4" }

    context 'when --pre is not given' do
      let(:args) { [version] }
      it "should output #{to_version} (clear the pre-release)" do
        expect { subject }.to output("#{to_version}\n").to_stdout
      end
    end

    context 'when --pre is given' do
      let(:args) { [version, '--pre'] }
      it "should output #{to_version}-pre.1 (use the default pre-release type 'pre')" do
        expect { subject }.to output("#{to_version}-pre.1\n").to_stdout
      end
    end

    context 'when --pre and --pre-type=alpha are given' do
      let(:args) { [version, '--pre', '--pre-type=alpha'] }
      it "should output #{to_version}-alpha.1 (use the given pre-release type)" do
        expect { subject }.to output("#{to_version}-alpha.1\n").to_stdout
      end
    end
  end

  context "when given VERSION is #{from_version}" do
    let(:version) { from_version }
    let(:args) { [version] }

    it "should output #{to_version}" do
      expect { subject }.to output("#{to_version}\n").to_stdout
    end

    context 'when given the --pre option' do
      let(:args) { [version, '--pre'] }

      it "should output #{to_version}-pre.1 (using the default pre-release type 'pre')" do
        expect { subject }.to output("#{to_version}-pre.1\n").to_stdout
      end
    end

    context 'when given the --pre and --pre-type=alpha options' do
      let(:args) { [version, '--pre', '--pre-type=alpha'] }

      it "should output #{to_version}-alpha.1 (using the pre-release type given)" do
        expect { subject }.to output("#{to_version}-alpha.1\n").to_stdout
      end
    end

    context 'when given the --build=AMD64 option' do
      let(:args) { [version, '--build=AMD64'] }

      it "should output #{to_version}+AMD64" do
        expect { subject }.to output("#{to_version}+AMD64\n").to_stdout
      end
    end

    context 'when given the --dry-run option' do
      let(:args) { [version, '--dry-run'] }

      # --dry-run is implied when VERSION is given, so no difference in the
      # functionality
      #
      it "should output #{to_version}" do
        expect { subject }.to output("#{to_version}\n").to_stdout
      end
    end

    context 'when given the --quiet option' do
      let(:args) { [version, '--quiet'] }

      # --dry-run is implied when VERSION is given, so no difference in the
      # functionality
      #
      it "should return #{from_version}" do
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

      it "should output #{to_version} and update the version in the version file to #{to_version}" do
        expect { subject }.to output("#{to_version}\n").to_stdout
        expect(File.read('VERSION')).to eq(to_version)
      end
    end

    context "when given --dry-run and the version file contains the version #{from_version}" do
      let(:args) { ['--dry-run'] }

      before { File.write('VERSION', from_version) }

      it "should output #{to_version} and leave the version in the version file alone" do
        expect { subject }.to output("#{to_version}\n").to_stdout
        expect(File.read('VERSION')).to eq(from_version)
      end
    end
  end
end

# Setup simplecov

require 'simplecov'
require 'simplecov-lcov'
require 'json'

SimpleCov.formatters = [SimpleCov::Formatter::HTMLFormatter, SimpleCov::Formatter::LcovFormatter]

# Fail the rspec run if code coverage falls below the configured threshold
#
# Skip this check if the NOCOV environment variable is set to TRUE
#
# ```Shell
# NOCOV=TRUE rspec
# ```
#
# Example of running the tests in an infinite loop writing failures to `fail.txt`:
#
# ```Shell
# while true; do
#   NOCOV=TRUE rspec spec/process_executer/monitored_pipe_spec.rb | sed -n '/^Failures:$/, /^Finished /p' >> fail.txt
# done
# ````
#
test_coverage_threshold = 100
SimpleCov.at_exit do
  unless RSpec.configuration.dry_run?
    SimpleCov.result.format!

    if ENV['NOCOV']&.upcase != 'TRUE' && SimpleCov.result.covered_percent < test_coverage_threshold
      warn "FAIL: RSpec Test coverage fell below #{test_coverage_threshold}%"

      warn "\nThe following lines were not covered by tests:\n"
      SimpleCov.result.files.each do |source_file| # SimpleCov::SourceFile
        source_file.missed_lines.each do |line| # SimpleCov::SourceFile::Line
          puts "  #{source_file.project_filename}:#{line.number}"
        end
      end
      warn "\n"

      exit 1
    end
  end
end

SimpleCov.start

# Make sure to require your project AFTER SimpleCov.start
#
require 'semverify'
