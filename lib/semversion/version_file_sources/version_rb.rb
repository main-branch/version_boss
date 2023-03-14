# frozen_string_literal: true

require 'semversion/version_file_sources/base'

module Semversion
  module VersionFileSources
    # Checks for the gem's version in a file named lib/**/version.rb
    #
    # @api public
    #
    class VersionRb < Base
      VERSION_REGEXP = /
        \A
          (?<content_before>
            .*
            VERSION\s*=\s*(?<quote>['"])
          )
          (?<version>#{Semversion::Semver::SEMVER_REGEXP.source})
          (?<content_after>\k<quote>.*)
        \z
      /xm

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
