# frozen_string_literal: true

require_relative 'regexp'

module VersionBoss
  module Semver
    # Parse and compare semver version strings
    #
    # This class will parse a semver version string that complies to Semantic
    # Versioning 2.0.0.
    #
    # Two Semver objects can be compared using the spaceship operator (<=>)
    # according to the rules of Semantic Versioning 2.0.0.
    #
    # @example Basic version parsing
    #   semver = VersionBoss::Semver.new('1.2.3')
    #   semver.major # => '1'
    #   semver.minor # => '2'
    #   semver.patch # => '3'
    #
    # @example Parsing a version with a pre-release identifier
    #   semver = VersionBoss::Semver.new('1.2.3-alpha.1')
    #   semver.pre_release # => 'alpha.1'
    #   semver.pre_release_identifiers # => ['alpha', '1']
    #
    # @example A version with build metadata
    #   semver = VersionBoss::Semver.new('1.2.3+build.1')
    #   semver.build_metadata # => 'build.1'
    #
    # @example Comparing versions
    #   semver1 = VersionBoss::Semver.new('1.2.3')
    #   semver2 = VersionBoss::Semver.new('1.2.4')
    #   semver1 <=> semver2 # => true
    #
    # See the Semantic Versioning 2.0.0 specification for more details.
    #
    # @see https://semver.org/spec/v2.0.0.html Semantic Versioning 2.0.0
    #
    # @api public
    #
    class Version
      include Comparable

      # Create a new Semver object
      #
      # @example
      #   version = VersionBoss::Semver.new('1.2.3-alpha.1')
      #
      # @param version [String] The version string to parse
      #
      # @raise [VersionBoss::Error] version is not a string or not a valid semver version
      #
      def initialize(version)
        assert_version_must_be_a_string(version)
        @version = version
        parse
        assert_valid_version
      end

      # @!attribute version [r]
      #
      # The complete version string
      #
      # @example
      #   semver = VersionBoss::Semver.new('1.2.3-alpha.1+build.001')
      #   semver.version #=> '1.2.3-alpha.1+build.001'
      #
      # @return [String]
      #
      # @api public
      #
      attr_reader :version

      # @attribute major [r]
      #
      # The major part of the version
      #
      # @example
      #   semver = VersionBoss::Semver.new('1.2.3-alpha.1+build.001')
      #   semver.major #=> '1'
      #
      # @return [String]
      #
      # @api public
      #
      attr_reader :major

      # @attribute minor [r]
      #
      # The minor part of the version
      #
      # @example
      #   semver = VersionBoss::Semver.new('1.2.3-alpha.1+build.001')
      #   semver.minor #=> '2'
      #
      # @return [String]
      #
      # @api public
      #
      attr_reader :minor

      # @attribute patch [r]
      #
      # The patch part of the version
      #
      # @example
      #   semver = VersionBoss::Semver.new('1.2.3-alpha.1+build.001')
      #   semver.patch #=> '3'
      #
      # @return [String]
      #
      # @api public
      #
      attr_reader :patch

      # @attribute pre_release [r]
      #
      # The pre_release part of the version
      #
      # Will be an empty string if the version has no pre_release part.
      #
      # @example
      #   semver = VersionBoss::Semver.new('1.2.3-alpha.1+build.001')
      #   semver.pre_release #=> 'alpha.1'
      #
      # @example When the version has no pre_release part
      #   semver = VersionBoss::Semver.new('1.2.3')
      #   semver.pre_release #=> ''
      #
      # @return [String]
      #
      # @api public
      #
      attr_reader :pre_release

      # @attribute pre_release_identifiers [r]
      #
      # The pre_release identifiers of the version
      #
      # @example
      #   semver = VersionBoss::Semver.new('1.2.3-alpha.1+build.001')
      #   semver.pre_release_identifiers #=> ['alpha', '1']
      #
      # @example When the version has no pre_release part
      #   semver = VersionBoss::Semver.new('1.2.3')
      #   semver.pre_release_identifiers #=> []
      #
      # @return [Array<String>]
      #
      # @api public
      #
      attr_reader :pre_release_identifiers

      # @attribute build_metadata [r]
      #
      # The build_metadata part of the version
      #
      # Will be an empty string if the version has no build_metadata part.
      #
      # @example
      #   semver = VersionBoss::Semver.new('1.2.3-alpha.1+build.001')
      #   semver.build_metadata #=> 'build.001'
      #
      # @example When the version has no build_metadata part
      #   semver = VersionBoss::Semver.new('1.2.3')
      #   semver.build_metadata #=> ''
      #
      # @return [String]
      #
      # @api public
      #
      attr_reader :build_metadata

      # Compare two Semver objects
      #
      # See the [Precedence Rules](https://semver.org/spec/v2.0.0.html#spec-item-11)
      # in the Semantic Versioning 2.0.0 Specification for more details.
      #
      # @example
      #   semver1 = VersionBoss::Semver.new('1.2.3')
      #   semver2 = VersionBoss::Semver.new('1.2.4')
      #   semver1 <=> semver2 # => -1
      #   semver2 <=> semver1 # => 1
      #
      # @example A Semver is equal to itself
      #   semver1 = VersionBoss::Semver.new('1.2.3')
      #   semver1 <=> semver1 # => 0
      #
      # @example A pre-release version is always older than a normal version
      #   semver1 = VersionBoss::Semver.new('1.2.3-alpha.1')
      #   semver2 = VersionBoss::Semver.new('1.2.3')
      #   semver1 <=> semver2 # => -1
      #
      # @example Pre-releases are compared by the parts of the pre-release version
      #   semver1 = VersionBoss::Semver.new('1.2.3-alpha.1')
      #   semver2 = VersionBoss::Semver.new('1.2.3-alpha.2')
      #   semver1 <=> semver2 # => -1
      #
      # @example Build metadata is ignored when comparing versions
      #   semver1 = VersionBoss::Semver.new('1.2.3+build.100')
      #   semver2 = VersionBoss::Semver.new('1.2.3+build.101')
      #   semver1 <=> semver2 # => 0
      #
      # @param other [Semver] the other Semver to compare to
      #
      # @return [Integer] -1 if self < other, 0 if self == other, or 1 if self > other
      #
      # @raise [VersionBoss::Error] other is not a semver
      #
      def <=>(other)
        assert_other_is_a_semver(other)

        result = compare_core_parts(other)

        return result unless result.zero? && pre_release != other.pre_release
        return 1 if pre_release.empty?
        return -1 if other.pre_release.empty?

        compare_pre_release_part(other)
      end

      # Determine if the version string is a valid semver
      #
      # Override this method in a subclass to provide extra or custom validation.
      #
      # @example
      #   VersionBoss::Semver.new('1.2.3').valid? # => true
      #   VersionBoss::Semver.new('1.2.3-alpha.1+build.001').valid? # => true
      #   VersionBoss::Semver.new('bogus').valid? # => raises VersionBoss::Error
      #
      # @return [Boolean] true if the version string is a valid semver
      #
      def valid?
        # If major is set, then so is everything else
        !major.nil?
      end

      # Two versions are equal if their version strings are equal
      #
      # @example
      #   VersionBoss::Semver.new('1.2.3') == '1.2.3' # => true
      #
      # @param other [Semver] the other Semver to compare to
      #
      # @return [Boolean] true if the version strings are equal
      #
      def ==(other)
        version == other.to_s
      end

      # The string representation of a Semver is its version string
      #
      # @example
      #   VersionBoss::Semver.new('1.2.3').to_s # => '1.2.3'
      #
      # @return [String] the version string
      #
      def to_s
        version
      end

      private

      # Parse @version into its parts
      # @return [void]
      # @api private
      def parse
        return unless (match_data = version.match(REGEXP_FULL))

        core_parts(match_data)
        pre_release_part(match_data)
        build_metadata_part(match_data)
      end

      # Compare the major, minor, and patch parts of this Semver to other
      # @param other [Semver] the other Semver to compare to
      # @return [Integer] -1 if self < other, 0 if self == other, or 1 if self > other
      # @api private
      def compare_core_parts(other)
        identifiers = [major.to_i, minor.to_i, patch.to_i]
        other_identifiers = [other.major.to_i, other.minor.to_i, other.patch.to_i]

        identifiers <=> other_identifiers
      end

      # Compare two pre-release identifiers
      #
      # Implements the rules for precedence for comparing two pre-release identifiers
      # from the Semantic Versioning 2.0.0 Specification.
      #
      # @param identifier [String, Integer] the identifier to compare
      # @param other_identifier [String, Integer] the other identifier to compare
      # @return [Integer] -1, 0, or 1
      # @api private
      def compare_identifiers(identifier, other_identifier)
        return 1 if other_identifier.nil?
        return -1 if identifier.is_a?(Integer) && other_identifier.is_a?(String)
        return 1 if other_identifier.is_a?(Integer) && identifier.is_a?(String)

        identifier <=> other_identifier
      end

      # Compare two pre-release version parts
      #
      # Implements the rules for precedence for comparing the pre-release part of
      # one version with the pre-release part of another version from the Semantic
      # Versioning 2.0.0 Specification.
      #
      # @param other [Semver] the other Semver to compare to
      # @return [Integer] -1, 0, or 1
      # @api private
      def compare_pre_release_part(other)
        pre_release_identifiers.zip(other.pre_release_identifiers).each do |field, other_field|
          result = compare_identifiers(field, other_field)
          return result unless result.zero?
        end
        pre_release_identifiers.size < other.pre_release_identifiers.size ? -1 : 0
      end

      # Raise a error if other is not a valid Semver
      # @param other [Semver] the other to check
      # @return [void]
      # @raise [VersionBoss::Error] if other is not a valid Semver
      # @api private
      def assert_other_is_a_semver(other)
        raise VersionBoss::Error, 'other must be a Semver' unless other.is_a?(VersionBoss::Semver::Version)
      end

      # Raise a error if the given version is not a string
      # @param version [Semver] the version to check
      # @return [void]
      # @raise [VersionBoss::Error] if the given version is not a string
      # @api private
      def assert_version_must_be_a_string(version)
        raise VersionBoss::Error, 'Version must be a string' unless version.is_a?(String)
      end

      # Raise a error if this version object is not a valid Semver
      # @return [void]
      # @raise [VersionBoss::Error] if other is not a valid Semver
      # @api private
      def assert_valid_version
        raise VersionBoss::Error, "Not a valid version string: #{version}" unless valid?
      end

      # Set the major, minor, and patch parts of this Semver
      # @param match_data [MatchData] the match data from the version string
      # @return [void]
      # @api private
      def core_parts(match_data)
        @major = match_data[:major]
        @minor = match_data[:minor]
        @patch = match_data[:patch]
      end

      # Set the pre-release of this Semver
      # @param match_data [MatchData] the match data from the version string
      # @return [void]
      # @api private
      def pre_release_part(match_data)
        @pre_release = match_data[:pre_release] || ''
        @pre_release_identifiers = @pre_release.split('.').map { |f| f =~ /\A\d+\z/ ? f.to_i : f }
      end

      # Set the build_metadata of this Semver
      # @param match_data [MatchData] the match data from the version string
      # @return [void]
      # @api private
      def build_metadata_part(match_data)
        @build_metadata = match_data[:build_metadata] || ''
      end
    end
  end
end
