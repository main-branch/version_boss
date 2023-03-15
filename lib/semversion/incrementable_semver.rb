# frozen_string_literal: true

require 'semversion/semver'

module Semversion
  # A Semversion::Semver with additional constraints on the pre-release part of the version
  #
  # A IncrementableSemver is valid if one of the two following conditions is met:
  #   1. The pre-release part is empty
  #   2. The pre-release part is composed of two identifiers, the first being a
  #      string and the second being an integer
  #
  # @api public
  #
  class IncrementableSemver < Semver
    # Create a new IncrementableSemver object
    #
    # @example
    #   Semversion::Semver.new('1.2.3').valid? # => true
    #   Semversion::Semver.new('1.2.3-alpha.1+build.001').valid? # => true
    #   Semversion::Semver.new('1.2.3-alpha').valid? # => raise ArgumentError
    #   Semversion::Semver.new('1.2.3-alpha.1.2').valid? # => raise ArgumentError
    #   Semversion::Semver.new('1.2.3-alpha.one').valid? # => raise ArgumentError
    #
    # @return [Boolean] true if the version string is a valid semver and meets the conditions above
    #
    def valid?
      super && (
        pre_release.empty? ||
        (
          pre_release_identifiers.size == 2 &&
          pre_release_identifiers[0].is_a?(String) &&
          pre_release_identifiers[1].is_a?(Integer)
        )
      )
    end

    DEFAULT_PRE_PREFIX = 'pre'

    # Increment the major version
    #
    # @example
    #   IncrementableSemversion::Semver.new('1.2.3').next_major # => IncrementableSemversion::Semver.new('2.0.0')
    #
    # @return [IncrementableSemver] a new IncrementableSemver object with the major version incremented
    #
    def next_major(pre: false, pre_prefix: DEFAULT_PRE_PREFIX, build_metadata: nil)
      version_string = "#{major.to_i + 1}.0.0"
      version_string += "-#{pre_prefix}.1" if pre
      build_metadata = self.build_metadata if build_metadata.nil?
      version_string += "+#{build_metadata}" unless build_metadata.empty?
      IncrementableSemver.new(version_string)
    end

    # Increment the minor version
    #
    # @example
    #   IncrementableSemversion::Semver.new('1.2.3').next_minor # => IncrementableSemversion::Semver.new('1.3.0')
    #
    # @return [IncrementableSemver] a new IncrementableSemver object with the major version incremented
    #
    def next_minor(pre: false, pre_prefix: DEFAULT_PRE_PREFIX, build_metadata: nil)
      version_string = "#{major}.#{minor.to_i + 1}.0"
      version_string += "-#{pre_prefix}.1" if pre
      build_metadata = self.build_metadata if build_metadata.nil?
      version_string += "+#{build_metadata}" unless build_metadata.empty?
      IncrementableSemver.new(version_string)
    end

    # Increment the patch version
    #
    # @example
    #   IncrementableSemversion::Semver.new('1.2.3').next_patch # => IncrementableSemversion::Semver.new('1.2.1')
    #
    # @return [IncrementableSemver] a new IncrementableSemver object with the major version incremented
    #
    def next_patch(pre: false, pre_prefix: DEFAULT_PRE_PREFIX, build_metadata: nil)
      version_string = "#{major}.#{minor}.#{patch.to_i + 1}"
      version_string += "-#{pre_prefix}.1" if pre
      build_metadata = self.build_metadata if build_metadata.nil?
      version_string += "+#{build_metadata}" unless build_metadata.empty?
      IncrementableSemver.new(version_string)
    end
  end
end
