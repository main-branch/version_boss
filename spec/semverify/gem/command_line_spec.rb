# frozen_string_literal: true

require 'tmpdir'

RSpec.describe Semverify::Gem::CommandLine do
  subject { described_class.start([*args]) }

  around do |example|
    Dir.mktmpdir do |dir|
      Dir.chdir(dir) do
        example.run
      end
    end
  end

  context 'with no arguments' do
    let(:args) { %w[] }
    it 'should show the help' do
      expect { subject }.to output(/^Commands:\n  /).to_stdout
    end
  end

  context 'with an invalid command' do
    let(:args) { %w[invalid] }
    it 'should exit with exitstatus 1 and an error to stderr' do
      expect { subject }.to exit_with(1, "Could not find command \"invalid\".\n")
    end
  end
end
