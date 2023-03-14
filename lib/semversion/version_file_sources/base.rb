# frozen_string_literal: true

require 'semversion/version_file'

module Semversion
  module VersionFileSources
    # Base class for a version file source which implements #find
    #
    # @api public
    #
    class Base
      # The first file from #glob whose content matches #content_regexp
      #
      # @example
      #   version_file = Semversion::VersionFileSources::Gemspec.find
      #
      # @return [Semversion::VersionFile, nil] the version file or nil if no version file was found
      #
      def self.find
        Dir[glob].filter_map do |path|
          if (match = File.read(path).match(content_regexp))
            Semversion::VersionFile.new(path, match[:content_before], match[:version], match[:content_after])
          end
        end.first
      end

      private

      # The version file regexp
      #
      # A regular expression that matches the version file and has three named captures:
      # - content_before: the content before the version
      # - version: the version
      # - content_after: the content after the version
      #
      # @return [Regexp]
      # @api private
      private_class_method def self.content_regexp
        raise NotImplementedError, 'You must implement #content_regexp in a subclass'
      end

      # A glob that matches potential version files
      #
      # Files matching this glob will be checked to see if they match #version_file_regexp
      #
      # @return [String]
      # @api private
      private_class_method def self.glob
        raise NotImplementedError, 'You must implement #glob in a subclass'
      end
    end
  end
end
