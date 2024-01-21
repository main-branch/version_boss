# frozen_string_literal: true

require 'tempfile'

RSpec.describe Semverify::VersionFileFactory do
  describe '.find' do
    subject { described_class.find }

    context 'when there is no version file' do
      around do |example|
        Dir.mktmpdir do |dir|
          Dir.chdir(dir) do
            example.run
          end
        end
      end

      it 'should return nil' do
        expect(subject).to be_nil
      end
    end

    context 'for a VERSION file' do
      around do |example|
        Dir.mktmpdir do |dir|
          Dir.chdir(dir) do
            File.write('VERSION', '1.2.3.pre.1')
            example.run
          end
        end
      end

      it { is_expected.to be_a(Semverify::VersionFile) }

      it do
        is_expected.to(
          have_attributes(
            path: 'VERSION',
            content_before: '',
            version: Semverify::IncrementableGemVersion.new('1.2.3.pre.1'),
            content_after: ''
          )
        )
      end
    end

    context 'for a version.rb file' do
      around do |example|
        Dir.mktmpdir do |dir|
          Dir.chdir(dir) do
            FileUtils.mkdir_p('lib/semverify')
            File.write('lib/semverify/version.rb', <<~VERSION_RB)
              module Semverify
                VERSION = '0.1.0'
              end
            VERSION_RB
            example.run
          end
        end
      end

      it { is_expected.to be_a(Semverify::VersionFile) }

      it do
        is_expected.to(
          have_attributes(
            path: 'lib/semverify/version.rb',
            content_before: "module Semverify\n  VERSION = '",
            version: Semverify::IncrementableGemVersion.new('0.1.0'),
            content_after: "'\nend\n"
          )
        )
      end
    end

    context 'for a gemspec file' do
      around do |example|
        Dir.mktmpdir do |dir|
          Dir.chdir(dir) do
            File.write('semverify.gemspec', <<~GEMSPEC)
              Gem::Specification.new do |spec|
                spec.version = '2.0.0.pre.1'
              end
            GEMSPEC
            example.run
          end
        end
      end

      it { is_expected.to be_a(Semverify::VersionFile) }

      it do
        is_expected.to(
          have_attributes(
            path: 'semverify.gemspec',
            content_before: "Gem::Specification.new do |spec|\n  spec.version = '",
            version: Semverify::IncrementableGemVersion.new('2.0.0.pre.1'),
            content_after: "'\nend\n"
          )
        )
      end
    end
  end
end
