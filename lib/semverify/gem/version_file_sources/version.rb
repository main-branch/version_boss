# frozen_string_literal: true

require_relative 'base'

module Semverify
  module Gem
    module VersionFileSources
      # Checks for the gem's version in a file named VERSION
      #
      # @api public
      #
      class Version < Base
        # The regexp to find the version and surrounding content within the version file
        VERSION_REGEXP = /
          \A
            (?<content_before>\s*)
            (?<version>#{REGEXP.source})
            (?<content_after>\s*)
          \z
        /x

        private

        # The version file regexp
        # @return [Regexp]
        # @api private
        private_class_method def self.content_regexp = VERSION_REGEXP

        # A glob that matches potential version files
        # @return [String]
        # @api private
        private_class_method def self.glob = 'VERSION'
      end
    end
  end
end
