# frozen_string_literal: true

require_relative 'regexp'

module VersionBoss
  module Gem
    # Parse and compare Ruby Gem version strings
    #
    # This class will parse and validate a Ruby Gem version string
    #
    # Two GemVersion objects can be compared using the spaceship operator (<=>)
    # according to the rules of precedence defined in
    # [the Gem::Version class](https://rubydoc.info/gems/rubygems-update/Gem/Version).
    #
    # @example Basic version parsing
    #   gem_version = VersionBoss::GemVersion.new('1.2.3')
    #   gem_version.major # => '1'
    #   gem_version.minor # => '2'
    #   gem_version.patch # => '3'
    #
    # @example Parsing a version with a pre-release identifier
    #   gem_version = VersionBoss::GemVersion.new('1.2.3.alpha.1')
    #   gem_version.pre_release # => 'alpha.1'
    #   gem_version.pre_release_identifiers # => ['alpha', '1']
    #
    # @example Separators are optional between pre-release identifiers
    #   gem_version1 = VersionBoss::GemVersion.new('1.2.3.alpha.1')
    #   gem_version2 = VersionBoss::GemVersion.new('1.2.3.alpha1')
    #   gem_version3 = VersionBoss::GemVersion.new('1.2.3alpha1')
    #
    #   gem_version1 == gem_version2 # => true
    #   gem_version1 == gem_version3 # => true
    #   gem_version2 == gem_version3 # => true
    #
    #   gem_version1.pre_release1 # => '.alpha.1'
    #   gem_version1.pre_release2 # => '.alpha1'
    #   gem_version1.pre_release3 # => 'alpha1'
    #
    #   gem_version1.pre_release_identifiers # => ['alpha', '1']
    #   gem_version2.pre_release_identifiers # => ['alpha', '1']
    #   gem_version3.pre_release_identifiers # => ['alpha', '1']
    #
    # @example Comparing versions
    #   gem_version1 = VersionBoss::GemVersion.new('1.2.3')
    #   gem_version2 = VersionBoss::GemVersion.new('1.2.4')
    #   gem_version1 <=> gem_version2 # => -1
    #   gem_version2 <=> gem_version3 # => 1
    #   gem_version1 <=> gem_version1 # => 0
    #
    # @see https://rubydoc.info/gems/rubygems-update/Gem/Version the Gem::Version class
    #
    # @api public
    #
    class Version
      include Comparable

      # Create a new GemVersion object
      #
      # @example
      #   version = VersionBoss::GemVersion.new('1.2.3.alpha.1')
      #
      # @param version [String] The version string to parse
      #
      # @raise [VersionBoss::Error] version is not a string or not a valid gem_version version
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
      #   gem_version = VersionBoss::GemVersion.new('1.2.3.alpha.1+build.001')
      #   gem_version.version #=> '1.2.3.alpha.1+build.001'
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
      #   gem_version = VersionBoss::GemVersion.new('1.2.3.alpha.1+build.001')
      #   gem_version.major #=> '1'
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
      #   gem_version = VersionBoss::GemVersion.new('1.2.3.alpha.1+build.001')
      #   gem_version.minor #=> '2'
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
      #   gem_version = VersionBoss::GemVersion.new('1.2.3.alpha.1+build.001')
      #   gem_version.patch #=> '3'
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
      #   gem_version = VersionBoss::GemVersion.new('1.2.3.alpha.1+build.001')
      #   gem_version.pre_release #=> 'alpha.1'
      #
      # @example When the version has no pre_release part
      #   gem_version = VersionBoss::GemVersion.new('1.2.3')
      #   gem_version.pre_release #=> ''
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
      #   gem_version = VersionBoss::GemVersion.new('1.2.3.alpha.1+build.001')
      #   gem_version.pre_release_identifiers #=> ['alpha', '1']
      #
      # @example When the version has no pre_release part
      #   gem_version = VersionBoss::GemVersion.new('1.2.3')
      #   gem_version.pre_release_identifiers #=> []
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
      #   gem_version = VersionBoss::GemVersion.new('1.2.3.alpha.1+build.001')
      #   gem_version.build_metadata #=> 'build.001'
      #
      # @example When the version has no build_metadata part
      #   gem_version = VersionBoss::GemVersion.new('1.2.3')
      #   gem_version.build_metadata #=> ''
      #
      # @return [String]
      #
      # @api public
      #
      attr_reader :build_metadata

      # Compare two GemVersion objects
      #
      # See the [Precedence Rules](https://gem_version.org/spec/v2.0.0.html#spec-item-11)
      # in the Semantic Versioning 2.0.0 Specification for more details.
      #
      # @example
      #   gem_version1 = VersionBoss::GemVersion.new('1.2.3')
      #   gem_version2 = VersionBoss::GemVersion.new('1.2.4')
      #   gem_version1 <=> gem_version2 # => -1
      #   gem_version2 <=> gem_version1 # => 1
      #
      # @example A GemVersion is equal to itself
      #   gem_version1 = VersionBoss::GemVersion.new('1.2.3')
      #   gem_version1 <=> gem_version1 # => 0
      #
      # @example A pre-release version is always older than a normal version
      #   gem_version1 = VersionBoss::GemVersion.new('1.2.3.alpha.1')
      #   gem_version2 = VersionBoss::GemVersion.new('1.2.3')
      #   gem_version1 <=> gem_version2 # => -1
      #
      # @example Pre-releases are compared by the parts of the pre-release version
      #   gem_version1 = VersionBoss::GemVersion.new('1.2.3.alpha.1')
      #   gem_version2 = VersionBoss::GemVersion.new('1.2.3.alpha.2')
      #   gem_version1 <=> gem_version2 # => -1
      #
      # @example Build metadata is ignored when comparing versions
      #   gem_version1 = VersionBoss::GemVersion.new('1.2.3+build.100')
      #   gem_version2 = VersionBoss::GemVersion.new('1.2.3+build.101')
      #   gem_version1 <=> gem_version2 # => 0
      #
      # @param other [GemVersion] the other GemVersion to compare to
      #
      # @return [Integer] -1 if self < other, 0 if self == other, or 1 if self > other
      #
      # @raise [VersionBoss::Error] other is not a gem_version
      #
      def <=>(other)
        assert_other_is_a_gem_version(other)

        core_comparison = compare_core_parts(other)
        pre_release_comparison = compare_pre_release_part(other)

        return core_comparison unless core_comparison.zero? && !pre_release_comparison.zero?

        return 1 if pre_release.empty?
        return -1 if other.pre_release.empty?

        pre_release_comparison
      end

      # Determine if the version string is a valid gem_version
      #
      # Override this method in a subclass to provide extra or custom validation.
      #
      # @example
      #   VersionBoss::GemVersion.new('1.2.3').valid? # => true
      #   VersionBoss::GemVersion.new('1.2.3.alpha.1+build.001').valid? # => true
      #   VersionBoss::GemVersion.new('bogus').valid? # => raises VersionBoss::Error
      #
      # @return [Boolean] true if the version string is a valid gem_version
      #
      def valid?
        # If major is set, then so is everything else
        !major.nil?
      end

      # Two versions are equal if their version strings are equal
      #
      # @example
      #   VersionBoss::GemVersion.new('1.2.3') == '1.2.3' # => true
      #
      # @param other [GemVersion] the other GemVersion to compare to
      #
      # @return [Boolean] true if the version strings are equal
      #
      def ==(other)
        version == other.to_s
      end

      # The string representation of a GemVersion is its version string
      #
      # @example
      #   VersionBoss::GemVersion.new('1.2.3').to_s # => '1.2.3'
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

      # Compare the major, minor, and patch parts of this GemVersion to other
      # @param other [GemVersion] the other GemVersion to compare to
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
      # @param other [GemVersion] the other GemVersion to compare to
      # @return [Integer] -1, 0, or 1
      # @api private
      def compare_pre_release_part(other)
        pre_release_identifiers.zip(other.pre_release_identifiers).each do |field, other_field|
          result = compare_identifiers(field&.identifier, other_field&.identifier)
          return result unless result.zero?
        end
        pre_release_identifiers.size < other.pre_release_identifiers.size ? -1 : 0
      end

      # Raise a error if other is not a valid Semver
      # @param other [GemVersion] the other to check
      # @return [void]
      # @raise [VersionBoss::Error] if other is not a valid Semver
      # @api private
      def assert_other_is_a_gem_version(other)
        raise VersionBoss::Error, 'other must be a Semver' unless other.is_a?(Version)
      end

      # Raise a error if the given version is not a string
      # @param version [GemVersion] the version to check
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
        @pre_release_identifiers = tokenize_pre_release_part(@pre_release)
      end

      # Set the build_metadata of this Semver
      # @param match_data [MatchData] the match data from the version string
      # @return [void]
      # @api private
      def build_metadata_part(_match_data)
        @build_metadata = ''
      end

      # A pre-release part of a version which consists of an optional prefix and an identifier
      # @api private
      class PreReleaseIdentifier
        # @attribute prefix [r]
        #
        # Gem versions can optionally prefix pre-release identifiers with a period
        #
        # The prefix is not significant when sorting.
        #
        # The prefix is saved so that the pre-release part can be reconstructed
        # exactly as it was given.
        #
        # @return [String] '.' if the pre-release type is prefixed with a period, otherwise ''
        #
        # @api private
        #
        attr_reader :prefix

        # @attribute identifier [r]
        #
        # The pre-release identifier
        #
        # The identifier is converted to an integer if it consists only of digits.
        # Otherwise, it is left as a string.
        #
        # @return [String, Integer]
        #
        # @api private
        #
        attr_reader :identifier

        # Create a new PreReleaseIdentifier keeping track of the optional prefix
        #
        # @example
        #   PreReleaseIdentifier.new('.pre') #=> #<PreReleaseIdentifier @identifier="pre", @prefix=".">
        #   PreReleaseIdentifier.new('pre') #=> #<PreReleaseIdentifier @identifier="pre", @prefix="">
        #   PreReleaseIdentifier.new('.1') #=> #<PreReleaseIdentifier @identifier=1, @prefix=".">
        #   PreReleaseIdentifier.new('1') #=> #<PreReleaseIdentifier @identifier=1, @prefix="">
        #
        # @param pre_release_part_str [String] the pre-release part string to parse
        #
        # @return [String]
        #
        # @api private
        #
        def initialize(pre_release_part_str)
          @prefix = pre_release_part_str.start_with?('.') ? '.' : ''
          @identifier = determine_part(pre_release_part_str)
        end

        private

        # Determine if the pre-release part is a number or a string
        #
        # @param pre_release_part_str [String] the pre-release part string to parse
        #
        # @return [String, Integer]
        #
        # @api private
        #
        def determine_part(pre_release_part_str)
          clean_str = pre_release_part_str.delete_prefix('.')
          clean_str.match?(/\A\d+\z/) ? clean_str.to_i : clean_str
        end
      end

      # Parse the pre-release part of the version into an array of identifiers
      #
      # A pre-release version is denoted by appending one or more pre-release identifiers
      # to the core version. The first pre-release identifier must consist of only ASCII letters.
      # Identifiers MUST NOT be empty. Numeric identifiers MUST NOT include leading zeroes.
      # Each identifier may be prefixed with a period '.'.
      #
      # @example
      #   tokenize_pre_release_part('.alpha.1') #=> [
      #     #<PreReleaseIdentifier @identifier="alpha", @prefix=".">,
      #     #<PreReleaseIdentifier @identifier=1, @prefix=".">
      #   ]
      #
      # @param str [String] the pre-release part string to parse (for example: '.pre.1')
      #
      # @return [Array<PreReleaseIdentifier>]
      #
      # @api private
      #
      def tokenize_pre_release_part(str)
        str.scan(/\.?\d+|\.?[a-zA-Z]+/).map { |pre_release_part_str| PreReleaseIdentifier.new(pre_release_part_str) }
      end
    end
  end
end
