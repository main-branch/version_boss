# frozen_string_literal: true

require 'tmpdir'

RSpec.describe VersionBoss::Gem::VersionFile do
  let(:version_file) { described_class.new(path, content_before, version, content_after) }

  let(:path) { 'lib/version_boss/version.rb' }
  let(:content_before) { <<~CONTENT_BEFORE.chomp }
    # frozen_string_literal: true

    module VersionBoss
      VERSION = '
  CONTENT_BEFORE

  let(:version) { VersionBoss::Gem::IncrementableVersion.new('1.2.3') }

  let(:content_after) { <<~CONTENT_AFTER }
    '
    end
  CONTENT_AFTER

  describe '#initialize' do
    subject { version_file }

    it do
      is_expected.to(
        have_attributes(
          path:,
          content_before:,
          version:,
          content_after:
        )
      )
    end

    context 'when the version is not an IncrementableVersion' do
      let(:version_file) { described_class.new(path, content_before, '2.4.0', content_after) }
      subject { version_file }

      it 'should raise a VersionBoss::Error' do
        expect { subject }.to raise_error(VersionBoss::Error, 'version must be an IncrementableVersion')
      end
    end
  end

  describe '#version=' do
    let(:new_version) { VersionBoss::Gem::IncrementableVersion.new('9.9.9') }

    let(:original_content) { <<~ORIGINAL_CONTENT }
      # frozen_string_literal: true

      module VersionBoss
        VERSION = '1.2.3'
      end
    ORIGINAL_CONTENT

    # :nocov: JRuby does not mark the #{new_version} as covered

    let(:expected_content) { <<~UPDATED_CONTENT }
      # frozen_string_literal: true

      module VersionBoss
        VERSION = '#{new_version}'
      end
    UPDATED_CONTENT

    # :nocov:

    around do |example|
      Dir.mktmpdir do |dir|
        Dir.chdir(dir) do
          FileUtils.mkdir_p(File.dirname(path))
          File.write(path, original_content)
          example.run
        end
      end
    end

    it 'should write the new version to the version file' do
      version_file.version = new_version
      actual_content = File.read(path)
      expect(actual_content).to eq(expected_content)
    end

    context 'when the new version is not an IncrementableVersion' do
      let(:new_version) { '9.9.9' }
      it 'should raise a VersionBoss::Error' do
        expect { version_file.version = new_version }.to(
          raise_error(VersionBoss::Error, 'new_version must be an IncrementableVersion')
        )
      end
    end
  end
end
