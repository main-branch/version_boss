# frozen_string_literal: true

module VersionBoss
  module Gem
    # Represents a file that contains the gem's version and can update the version
    #
    # Use VersionFileFactory.find create a VersionFile instance.
    #
    # @api public
    #
    class VersionFile
      # Create an VersionFile instance
      #
      # Use VersionFileFactory.find create a VersionFile instance.
      #
      # @example
      #   version_file = VersionFile.new('VERSION', 'VERSION = "', '1.2.3', '"')
      #
      # @param path [String] the path to the file relative to the current directory
      # @param content_before [String] the content before the version
      # @param version [String] the version
      # @param content_after [String] the content after the version
      #
      # @raise [VersionBoss::Error] if the version is not an IncrementableVersion
      #
      # @api private
      #
      def initialize(path, content_before, version, content_after)
        raise VersionBoss::Error, 'version must be an IncrementableVersion' unless
          version.is_a?(VersionBoss::Gem::IncrementableVersion)

        @path = path
        @content_before = content_before
        @version = version
        @content_after = content_after
      end

      # @!attribute [r]
      #
      # The path to the file relative to the current directory
      #
      # @example
      #   version_file = VersionFile.new('lib/version_boss/version.rb', 'VERSION = "', '1.2.3', '"')
      #   version_file.path # => 'lib/version_boss/version.rb'
      # @return [String]
      # @api public
      attr_reader :path

      # @!attribute [r]
      #
      # The content in the version file before the version
      #
      # @example
      #   version_file = VersionFile.new('lib/version_boss/version.rb', 'VERSION = "', '1.2.3', '"')
      #   version_file.content_before # => 'VERSION = "'
      # @return [String]
      # @api public
      attr_reader :content_before

      # @!attribute [r]
      #
      # The version from the version file
      #
      # @example
      #   version = VersionBoss::IncrementableVersion.new('1.2.3')
      #   version_file = VersionFile.new('lib/version_boss/version.rb', 'VERSION = "', version, '"')
      #   version_file.version.to_s # => '1.2.3'
      # @return [VersionBoss::IncrementableVersion]
      # @raise [VersionBoss::Error] if the version is not an IncrementableVersion
      # @api public
      attr_reader :version

      # @!attribute [r]
      #
      # The content in the version file before the version
      #
      # @example
      #   version_file = VersionFile.new('lib/version_boss/version.rb', 'VERSION = "', '1.2.3', '"')
      #   version_file.content_after # => '"'
      # @return [String]
      # @api public
      attr_reader :content_after

      # Update the version in the version file
      #
      # @param new_version [VersionBoss::IncrementableVersion] the new version
      # @example
      #   version_file = VersionFile.new('lib/version_boss/version.rb', 'VERSION = "', '1.2.3', '"')
      #   version_file.version = '1.2.4'
      # @return [Void]
      # @raise [VersionBoss::Error] if new_version is not an IncrementableVersion
      # @api public
      #
      def version=(new_version)
        raise VersionBoss::Error, 'new_version must be an IncrementableVersion' unless
          new_version.is_a?(VersionBoss::Gem::IncrementableVersion)

        @version = version
        File.write(path, content_before + new_version.to_s + content_after)
      end
    end
  end
end
