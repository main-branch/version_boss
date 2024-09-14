# frozen_string_literal: true

require_relative 'version'

module VersionBoss
  module Semver
    # A Semver Version with additional constraints on the pre-release part of the version
    #
    # An IncrementableVersion is valid if one of the two following conditions is met:
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
    class IncrementableVersion < Version
      # Create a new IncrementableVersion object
      #
      # @example
      #   IncrementableVersion.new('1.2.3').valid? # => true
      #   IncrementableVersion.new('1.2.3-alpha.1+build.001').valid? # => true
      #   IncrementableVersion.new('1.2.3-alpha').valid? # => raise VersionBoss::Error
      #   IncrementableVersion.new('1.2.3-alpha.1.2').valid? # => raise VersionBoss::Error
      #   IncrementableVersion.new('1.2.3-alpha.one').valid? # => raise VersionBoss::Error
      #   IncrementableVersion.new('').valid? # => raise VersionBoss::Error
      #
      # @return [Boolean] true if the version string is a valid semver and meets the conditions above
      #
      def valid?
        super && (pre_release.empty? || (pre_release_identifiers.size == 2 && pre_number.is_a?(Integer)))
      end

      # The default pre-release identifier
      DEFAULT_PRE_TYPE = 'pre'

      # Increment the major version
      #
      # @example
      #   IncrementableVersionify::Semver.new('1.2.3').next_major # => IncrementableVersionify::Semver.new('2.0.0')
      #
      # @return [IncrementableVersion] a new IncrementableVersion object with the major version incremented
      #
      def next_major(pre: false, pre_type: DEFAULT_PRE_TYPE, build_metadata: nil)
        version_string = "#{major.to_i + 1}.0.0"
        version_string += "-#{pre_type}.1" if pre
        build_metadata = self.build_metadata if build_metadata.nil?
        version_string += "+#{build_metadata}" unless build_metadata.empty?
        IncrementableVersion.new(version_string)
      end

      # Increment the minor version
      #
      # @example
      #   IncrementableVersionify::Semver.new('1.2.3').next_minor # => IncrementableVersionify::Semver.new('1.3.0')
      #
      # @return [IncrementableVersion] a new IncrementableVersion object with the major version incremented
      #
      def next_minor(pre: false, pre_type: DEFAULT_PRE_TYPE, build_metadata: nil)
        version_string = "#{major}.#{minor.to_i + 1}.0"
        version_string += "-#{pre_type}.1" if pre
        build_metadata = self.build_metadata if build_metadata.nil?
        version_string += "+#{build_metadata}" unless build_metadata.empty?
        IncrementableVersion.new(version_string)
      end

      # Increment the patch version
      #
      # @example
      #   IncrementableVersionify::Semver.new('1.2.3').next_patch # => IncrementableVersionify::Semver.new('1.2.1')
      #
      # @return [IncrementableVersion] a new IncrementableVersion object with the patch part incremented
      #
      def next_patch(pre: false, pre_type: DEFAULT_PRE_TYPE, build_metadata: nil)
        version_string = "#{major}.#{minor}.#{patch.to_i + 1}"
        version_string += "-#{pre_type}.1" if pre
        build_metadata = self.build_metadata if build_metadata.nil?
        version_string += "+#{build_metadata}" unless build_metadata.empty?
        IncrementableVersion.new(version_string)
      end

      # Increment the pre_release part of the version
      #
      # @example
      #   IncrementableVersionify::Semver.new('1.2.3-pre.1').next_patch.to_s # => '1.2.3-pre.2'
      #
      # @return [IncrementableVersion] a new IncrementableVersion object with the pre_release part incremented
      #
      def next_pre(pre_type: nil, build_metadata: nil)
        assert_is_a_pre_release_version
        version_string = "#{major}.#{minor}.#{patch}"
        version_string += next_pre_part(pre_type)
        build_metadata ||= self.build_metadata
        version_string += "+#{build_metadata}" unless build_metadata.empty?
        IncrementableVersion.new(version_string)
      end

      # Drop the pre-release part of the version
      #
      # @example
      #   IncrementableVersionify::Semver.new('1.2.3-pre.1').next_release.to_s # => '1.2.3'
      #
      # @return [IncrementableVersion] a new IncrementableVersion object with the pre_release part dropped
      # @raise [VersionBoss::Error] if the version is not a pre-release version
      #
      def next_release(build_metadata: nil)
        assert_is_a_pre_release_version
        version_string = "#{major}.#{minor}.#{patch}"
        build_metadata ||= self.build_metadata
        version_string += "+#{build_metadata}" unless build_metadata.empty?
        IncrementableVersion.new(version_string)
      end

      # The pre-release type (for example, 'alpha', 'beta', 'pre', etc.)
      #
      # @example
      #   IncrementableVersionify::Semver.new('1.2.3-pre.1').pre_type # => 'pre'
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
      #   IncrementableVersionify::Semver.new('1.2.3-pre.1').pre_number # => 1
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
      # @raise [VersionBoss::Error] if the version is not a pre-release version
      # @api private
      def assert_is_a_pre_release_version
        return unless pre_release.empty?

        raise VersionBoss::Error, 'Cannot increment the pre-release part of a release version'
      end

      # Raise an error if new pre-release type is less than the old pre-release type
      #
      # If the new pre-release type is lexically less than the old pre-release type,
      # then raise an error because the resulting error would sort before the existing
      # version.
      #
      # @return [void]
      # @raise [VersionBoss::Error] if the pre-release type is not valid
      # @api private
      def assert_pre_type_is_valid(pre_type)
        return if self.pre_type <= pre_type

        # :nocov: JRuby coverage does not report this line correctly
        message = 'Cannot increment the pre-release identifier ' \
                  "from '#{self.pre_type}' to '#{pre_type}' " \
                  "because '#{self.pre_type}' is lexically less than '#{pre_type}'"
        # :nocov:

        raise VersionBoss::Error, message
      end

      # Return the next pre-release part
      # @param pre_type [String, nil] the given pre-release type or nil to use the existing pre-release type
      # @return [String]
      # @api private
      def next_pre_part(pre_type)
        pre_type ||= self.pre_type
        assert_pre_type_is_valid(pre_type)
        next_pre_number = self.pre_type == pre_type ? (pre_number + 1) : 1
        "-#{pre_type}.#{next_pre_number}"
      end
    end
  end
end
