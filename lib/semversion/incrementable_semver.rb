# frozen_string_literal: true

require 'semversion/semver'

module Semversion
  # A Semversion::Semver with additional constraints on the pre-release part of the version
  #
  # A IncrementableSemver is valid if one of the two following conditions is met:
  #   1. The pre-release part is empty
  #   2. The pre-release part is composed of two dot-separated identifiers:
  #     * the first being a String representing the pre-release type (e.g. 'alpha',
  #       'beta', etc.). The default pre-release type is 'pre'
  #     * the second being an Integer representing the pre-release sequence number
  #       (starting at 1)
  #
  # Valid versions with pre-release parts: `1.2.3-alpha.1`, `1.2.3-beta.2`, `1.2.3-pre.3`
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
          pre_type.is_a?(String) &&
          pre_number.is_a?(Integer)
        )
      )
    end

    # The default pre-release identifier
    DEFAULT_PRE_TYPE = 'pre'

    # Increment the major version
    #
    # @example
    #   IncrementableSemversion::Semver.new('1.2.3').next_major # => IncrementableSemversion::Semver.new('2.0.0')
    #
    # @return [IncrementableSemver] a new IncrementableSemver object with the major version incremented
    #
    def next_major(pre: false, pre_type: DEFAULT_PRE_TYPE, build_metadata: nil)
      version_string = "#{major.to_i + 1}.0.0"
      version_string += "-#{pre_type}.1" if pre
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
    def next_minor(pre: false, pre_type: DEFAULT_PRE_TYPE, build_metadata: nil)
      version_string = "#{major}.#{minor.to_i + 1}.0"
      version_string += "-#{pre_type}.1" if pre
      build_metadata = self.build_metadata if build_metadata.nil?
      version_string += "+#{build_metadata}" unless build_metadata.empty?
      IncrementableSemver.new(version_string)
    end

    # Increment the patch version
    #
    # @example
    #   IncrementableSemversion::Semver.new('1.2.3').next_patch # => IncrementableSemversion::Semver.new('1.2.1')
    #
    # @return [IncrementableSemver] a new IncrementableSemver object with the patch part incremented
    #
    def next_patch(pre: false, pre_type: DEFAULT_PRE_TYPE, build_metadata: nil)
      version_string = "#{major}.#{minor}.#{patch.to_i + 1}"
      version_string += "-#{pre_type}.1" if pre
      build_metadata = self.build_metadata if build_metadata.nil?
      version_string += "+#{build_metadata}" unless build_metadata.empty?
      IncrementableSemver.new(version_string)
    end

    # Increment the pre_release part of the version
    #
    # @example
    #   IncrementableSemversion::Semver.new('1.2.3-pre.1').next_patch.to_s # => '1.2.3-pre.2'
    #
    # @return [IncrementableSemver] a new IncrementableSemver object with the pre_release part incremented
    #
    def next_pre(pre_type: nil, build_metadata: nil)
      assert_is_a_pre_release_version
      version_string = "#{major}.#{minor}.#{patch}"
      pre_type ||= self.pre_type
      assert_pre_type_is_valid(pre_type)
      next_pre_number = self.pre_type == pre_type ? (pre_number + 1) : 1
      version_string += "-#{pre_type}.#{next_pre_number}"
      build_metadata ||= self.build_metadata
      version_string += "+#{build_metadata}" unless build_metadata.empty?
      IncrementableSemver.new(version_string)
    end

    # Drop the pre-release part of the version
    #
    # @example
    #   IncrementableSemversion::Semver.new('1.2.3-pre.1').next_release.to_s # => '1.2.3'
    #
    # @return [IncrementableSemver] a new IncrementableSemver object with the pre_release part dropped
    # @raise [Semversion::Error] if the version is not a pre-release version
    #
    def next_release(build_metadata: nil)
      assert_is_a_pre_release_version
      version_string = "#{major}.#{minor}.#{patch}"
      build_metadata ||= self.build_metadata
      version_string += "+#{build_metadata}" unless build_metadata.empty?
      IncrementableSemver.new(version_string)
    end

    # The pre-release type (for example, 'alpha', 'beta', 'pre', etc.)
    #
    # @example
    #   IncrementableSemversion::Semver.new('1.2.3-pre.1').pre_type # => 'pre'
    #
    # @return [String]
    #
    def pre_type
      pre_release_identifiers[0]
    end

    # The pre-release sequence number
    #
    # The pre-release sequence number starts at 1 for each pre-release type.
    #
    # @example
    #   IncrementableSemversion::Semver.new('1.2.3-pre.1').pre_number # => 1
    #
    # @return [Integer]
    #
    def pre_number
      pre_release_identifiers[1]
    end

    private

    # Raise an error if the version is not a pre-release version
    #
    # @return [void]
    # @raise [Semversion::Error] if the version is not a pre-release version
    # @api private
    def assert_is_a_pre_release_version
      return unless pre_release.empty?

      raise Semversion::Error, 'Cannot increment the pre-release part of a release version'
    end

    # Raise an error if new pre-release type is less than the old pre-release type
    #
    # If the new pre-release type is lexically less than the old pre-release type,
    # then raise an error because the resulting error would sort before the existing
    # version.
    #
    # @return [void]
    # @raise [Semversion::Error] if the pre-release type is not valid
    # @api private
    def assert_pre_type_is_valid(pre_type)
      return if self.pre_type <= pre_type

      message = 'Cannot increment the pre-release identifier ' \
                "from '#{self.pre_type}' to '#{pre_type}' " \
                "because '#{self.pre_type}' is lexically less than '#{pre_type}'"

      raise Semversion::Error, message
    end
  end
end
