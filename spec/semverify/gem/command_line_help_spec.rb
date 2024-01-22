# frozen_string_literal: true

require 'tmpdir'

RSpec.describe Semverify::Gem::CommandLine do
  around do |example|
    Dir.mktmpdir do |dir|
      Dir.chdir(dir) do
        example.run
      end
    end
  end

  context 'help' do
    subject { described_class.start(['help', *args]) }

    context 'with no command' do
      let(:args) { %w[] }
      it 'should list the commands' do
        expect { subject }.to output(/^Commands:\n  /).to_stdout
      end
    end

    context 'with a command' do
      let(:args) { %w[current] }
      it 'should show the help for that command' do
        expect { subject }.to output(/^Usage:\n  [^ ]+ current \[-q\]\n/).to_stdout
      end
    end

    context 'with and invalid command' do
      let(:args) { %w[invalid] }
      it 'should exist with exitstatus 1 and an error to stderr' do
        expect { subject }.to exit_with(1, "Could not find command \"invalid\".\n")
      end
    end
  end
end
