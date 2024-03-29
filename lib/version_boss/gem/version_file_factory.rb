# frozen_string_literal: true

require_relative 'version_file_sources'

module VersionBoss
  module Gem
    # Finds the file that contains the gem's version and returns a VersionFile instance
    #
    # @api public
    #
    class VersionFileFactory
      # The list of VersionFileSources to check for the version file
      #
      # The order of the list is important. The first VersionFileSource that finds a version file will be used.
      #
      VERSION_FILE_SOURCES = [
        VersionBoss::Gem::VersionFileSources::Version,
        VersionBoss::Gem::VersionFileSources::VersionRb,
        VersionBoss::Gem::VersionFileSources::Gemspec
      ].freeze

      # Finds the version file for the gem
      #
      # @example
      #   version_file = VersionBoss::Gem::VersionFileFactory.find
      #   version_file.path # => 'lib/version_boss/version.rb'
      #   version_file.version # => '1.2.3'
      #
      # @return [VersionBoss::VersionFile, nil] the version file or nil if no version file was found
      #
      def self.find
        VERSION_FILE_SOURCES.each do |version_file_source|
          version_file = version_file_source.find
          return version_file if version_file
        end
        nil
      end
    end
  end
end
