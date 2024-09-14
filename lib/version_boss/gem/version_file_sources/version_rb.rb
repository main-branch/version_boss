# frozen_string_literal: true

require_relative 'base'

module VersionBoss
  module Gem
    module VersionFileSources
      # Checks for the gem's version in a file named lib/**/version.rb
      #
      # @api public
      #
      class VersionRb < Base
        # :nocov: JRuby does not mark the line with VersionBoss::Gem::REGEXP.source as covered

        # The regexp to find the version and surrounding content within the version.rb file
        VERSION_REGEXP = /
          \A
            (?<content_before>
              .*
              VERSION\s*=\s*(?<quote>['"])
            )
            (?<version>#{REGEXP.source})
            (?<content_after>\k<quote>.*)
          \z
        /xm

        # :nocov:

        private

        # The version file regexp
        # @return [Regexp]
        # @api private
        private_class_method def self.content_regexp = VERSION_REGEXP

        # A glob that matches potential version files
        # @return [String]
        # @api private
        private_class_method def self.glob = 'lib/**/version.rb'
      end
    end
  end
end
