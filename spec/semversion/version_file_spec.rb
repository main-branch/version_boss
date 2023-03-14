# frozen_string_literal: true

RSpec.describe Semversion::VersionFile do
  let(:version_file) { described_class.new(path, content_before, version, content_after) }

  let(:path) { 'lib/semversion/version.rb' }
  let(:content_before) { <<~CONTENT_BEFORE.chomp }
    # frozen_string_literal: true

    module Semversion
      VERSION = '
  CONTENT_BEFORE

  let(:version) { '1.2.3' }

  let(:content_after) { <<~CONTENT_AFTER }
    '
    end
  CONTENT_AFTER

  describe '#initialize' do
    subject { version_file }

    it do
      is_expected.to(
        have_attributes(
          path: path,
          content_before: content_before,
          version: version,
          content_after: content_after
        )
      )
    end
  end

  describe '#version=' do
    let(:new_version) { '9.9.9' }

    let(:original_content) { <<~ORIGINAL_CONTENT }
      # frozen_string_literal: true

      module Semversion
        VERSION = '1.2.3'
      end
    ORIGINAL_CONTENT

    let(:expected_content) { <<~UPDATED_CONTENT }
      # frozen_string_literal: true

      module Semversion
        VERSION = '#{new_version}'
      end
    UPDATED_CONTENT

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
  end
end
