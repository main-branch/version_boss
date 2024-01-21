# frozen_string_literal: true

require 'semverify/version_file_sources/base'

module Semverify
  module VersionFileSources
    # Checks for the gem's version in a file named *.gemspec
    #
    # @api public
    #
    class Gemspec < Base
      # The regexp to find the version and surrounding content within the gemspec
      VERSION_REGEXP = /
        \A
          (?<content_before>
            .*
            \.version\s*=\s*(?<quote>['"])
          )
          (?<version>#{Semverify::RUBYVER_REGEXP.source})
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
      private_class_method def self.glob = '*.gemspec'
    end
  end
end
