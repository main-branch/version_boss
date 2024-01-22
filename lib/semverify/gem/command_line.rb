# frozen_string_literal: true

require 'thor'

module Semverify
  module Gem
    # rubocop:disable Metrics/ClassLength

    # The semverify cli
    #
    # @example
    #   require 'semverify'
    #
    #   Semverify::CommandLine.start(ARGV)
    #
    # @api private
    #
    class CommandLine < Thor
      # Tell Thor to exit with a non-zero status code if a command fails
      def self.exit_on_failure? = true

      desc 'current [-q]', 'Show the current gem version'

      long_desc <<-LONG_DESC
      Output the current gem version from the file that stores the gem version.

      The command fails if the gem version could not be found or is invalid.

      Use `--quiet` to ensure that a gem version could be found and is valid without producing any output.
      LONG_DESC

      option :quiet, type: :boolean, aliases: '-q', desc: 'Do not print the current version to stdout'

      # Show the current gem version
      # @return [void]
      def current
        version_file = Semverify::Gem::VersionFileFactory.find

        if version_file.nil?
          warn 'version file not found or is not valid' unless options[:quiet]
          exit 1
        end

        puts version_file.version unless options[:quiet]
      end

      desc 'file [-q]', 'Show the path to the file containing the gem version'

      long_desc <<-LONG_DESC
      Output the relative path to the file that stores the gem version.

      The command fails if the gem version could not be found.

      Use `--quiet` to ensure that a gem version could be found without producing any output.
      LONG_DESC

      option :quiet, type: :boolean, aliases: '-q', desc: 'Do not print the version file path to stdout'

      # Show the gem's version file
      # @return [void]
      def file
        version_file = Semverify::Gem::VersionFileFactory.find

        if version_file.nil?
          warn 'version file not found or is not valid' unless options[:quiet]
          exit 1
        end

        puts version_file.path unless options[:quiet]
      end

      desc 'next-major [VERSION] [-p [-t TYPE]] [-b BUILD] [-n] [-q]', "Increment the version's major part"

      long_desc <<-LONG_DESC
      Increase the current gem version to the next major version, update the
      file that stores the version, and output the resulting version to stdout.

      Increments 1.x.y to 2.0.0.

      The command fails if the current gem version file could not be found or
      if the version is not valid.

      If VERSION is given, use that instead of the current gem version. Giving
      VERSION implies --dry-run. The command fails if VERSION is not valid.

      --pre can be used to specify that the version should be incremented AND
      given a pre-release part. For instance:

      $ semverify next-major --pre

      increments '1.2.3' to '2.0.0.pre.1'.

      By default, the pre-release type is 'pre'. --pre-type=TYPE can be used with
      --pre to specify a different pre-release type such as alpha, beta, rc, etc.
      For instance:

      $ semverify next-major --pre --pre-type=alpha

      increments '1.2.3' to '2.0.0-alpha.1'.

      The command fails if the existing pre-release type is not lexically less than or
      equal to TYPE. For example, it the current version is '1.2.3-beta.1' and TYPE
      is 'alpha', the the command will fail since the new version would sort before the
      existing version ('beta' is not less than or equal to 'alpha').

      Use --build=BUILD to set the build metadata for the new version (See
      [Build Metadata in the Semantic Versioning Specification](https://semver.org/spec/v2.0.0.html#spec-item-10)).
      If --build is not given, the incremented version retain the previous build
      metadata. Pass an empty string to remove the build metadata (--build="")

      Use --dry-run to run this command without updating the version file.

      Use --quiet to increment the version without producing any output.
      LONG_DESC

      option :pre, type: :boolean, aliases: '-p', desc: 'Create a pre-release version'
      option :'pre-type', type: :string, aliases: '-t', default: 'pre', banner: 'TYPE',
                          desc: 'The type of pre-release version (alpha, beta, etc.)'
      option :build, type: :string, aliases: '-b', desc: 'The build metadata to add to the version'
      option :'dry-run', type: :boolean, aliases: '-n', desc: 'Do not write the new version to the version file'
      option :quiet, type: :boolean, aliases: '-q', desc: 'Do not print the new version to stdout'

      # Increment the gem version's major part
      # @param version [String, nil] The version to increment or nil to use the version
      #   from the gem's version file
      # @return [void]
      def next_major(version = nil)
        increment_core_version(:next_major, version)
      end

      desc 'next-minor [VERSION] [-p [-t TYPE]] [-b BUILD] [-n] [-q]', "Increment the version's minor part"

      long_desc <<-LONG_DESC
      Increase the current gem version to the next minor version, update the
      file that stores the version, and output the resulting version to stdout.

      Increments 1.2.y to 1.3.0.

      The command fails if the current gem version file could not be found or
      if the version is not valid.

      If VERSION is given, use that instead of the current gem version. Giving
      VERSION implies --dry-run. The command fails if VERSION is not valid.

      --pre can be used to specify that the version should be incremented AND
      given a pre-release part. For instance:

      $ semverify next-minor --pre

      increments '1.2.3' to '2.0.0.pre.1'.

      By default, the pre-release type is 'pre'. --pre-type=TYPE can be used with
      --pre to specify a different pre-release type such as alpha, beta, rc, etc.
      For instance:

      $ semverify next-patch --pre --pre-type=alpha

      increments '1.2.3' to '1.2.4-alpha.1'.

      The command fails if the existing pre-release type is not lexically less than or
      equal to TYPE. For example, it the current version is '1.2.3-beta.1' and TYPE
      is 'alpha', the the command will fail since the new version would sort before the
      existing version ('beta' is not less than or equal to 'alpha').

      Use --build=BUILD to set the build metadata for the new version (See
      [Build Metadata in the Semantic Versioning Specification](https://semver.org/spec/v2.0.0.html#spec-item-10)).
      If --build is not given, the incremented version retain the previous build
      metadata. Pass an empty string to remove the build metadata (--build="")

      Use --dry-run to run this command without updating the version file.

      Use --quiet to increment the version without producing any output.
      LONG_DESC

      option :pre, type: :boolean, aliases: '-p', desc: 'Create a pre-release version'
      option :'pre-type', type: :string, aliases: '-t', default: 'pre', banner: 'TYPE',
                          desc: 'The type of pre-release version (alpha, beta, etc.)'
      option :build, type: :string, aliases: '-b', desc: 'The build metadata to add to the version'
      option :'dry-run', type: :boolean, aliases: '-n', desc: 'Do not write the new version to the version file'
      option :quiet, type: :boolean, aliases: '-q', desc: 'Do not print the new version to stdout'

      # Increment the gem version's minor part
      # @param version [String, nil] The version to increment or nil to use the version
      #   from the gem's version file
      # @return [void]
      def next_minor(version = nil)
        increment_core_version(:next_minor, version)
      end

      desc 'next-patch [VERSION] [-p [-t TYPE]] [-b BUILD] [-n] [-q]', "Increment the version's patch part"

      long_desc <<-LONG_DESC
      Increase the current gem version to the next patch version, update the
      file that stores the version, and output the resulting version to stdout.

      Increments 1.2.3 to 1.2.4.

      The command fails if the current gem version file could not be found or
      if the version is not valid.

      If VERSION is given, use that instead of the current gem version. Giving
      VERSION implies --dry-run. The command fails if VERSION is not valid.

      --pre can be used to specify that the version should be incremented AND
      given a pre-release part. For instance:

      $ semverify next-patch --pre

      increments '1.2.3' to '1.2.4.pre.1'.

      By default, the pre-release type is 'pre'. --pre-type=TYPE can be used with
      --pre to specify a different pre-release type such as alpha, beta, rc, etc.
      For instance:

      $ semverify next-patch --pre --pre-type=alpha

      increments '1.2.3' to '1.2.4-alpha.1'.

      The command fails if the existing pre-release type is not lexically less than or
      equal to TYPE. For example, it the current version is '1.2.3-beta.1' and TYPE
      is 'alpha', the the command will fail since the new version would sort before the
      existing version ('beta' is not less than or equal to 'alpha').

      Use --build=BUILD to set the build metadata for the new version (See
      [Build Metadata in the Semantic Versioning Specification](https://semver.org/spec/v2.0.0.html#spec-item-10)).
      If --build is not given, the incremented version retain the previous build
      metadata. Pass an empty string to remove the build metadata (--build="")

      Use --dry-run to run this command without updating the version file.

      Use --quiet to increment the version without producing any output.
      LONG_DESC

      option :pre, type: :boolean, aliases: '-p', desc: 'Create a pre-release version'
      option :'pre-type', type: :string, aliases: '-t', default: 'pre', banner: 'TYPE',
                          desc: 'The type of pre-release version (alpha, beta, etc.)'
      option :build, type: :string, aliases: '-b', desc: 'The build metadata to add to the version'
      option :'dry-run', type: :boolean, aliases: '-n', desc: 'Do not write the new version to the version file'
      option :quiet, type: :boolean, aliases: '-q', desc: 'Do not print the new version to stdout'

      # Increment the gem version's patch part
      # @param version [String, nil] The version to increment or nil to use the version
      #   from the gem's version file
      # @return [void]
      def next_patch(version = nil)
        increment_core_version(:next_patch, version)
      end

      desc 'next-pre [VERSION] [-t TYPE] [-b BUILD] [-n] [-q]', "Increment the version's pre-release part"

      long_desc <<-LONG_DESC
      Increase the current gem version to the next pre-release version, update the
      file that stores the version, and output the resulting version to stdout.

      The command fails if  the current gem version file could not be found or
      the version is not a valid pre-release version.

      If VERSION is given, use that instead of the current gem version. Giving
      VERSION implies --dry-run. The command fails if VERSION is not a valid
      pre-release version.

      By default, the existing pre-release type is preserved. For instance:

      $ semverify next-pre

      Increments 1.2.3-alpha.1 to 1.2.3-alpha.2.

      --pre-type=TYPE can be used to change the pre-release type to TYPE (typical
      examples include alpha, beta, rc, etc.). If the pre-release type is changed,
      the pre-release number is reset to 1.

      For example, if the version starts as 1.2.3-alpha.4, then:

      $ semverify current
      1.2.3-alpha.4
      $ semver next-pre --pre-type=beta
      1.2.3-beta.1
      $ semver next-pre --pre-type=beta
      1.2.3-beta.2
      $ semver next-pre --pre-type=rc
      1.2.3-rc.1
      $ semverify next-release
      1.2.3

      The command fails if the existing pre-release type is not lexically less than or
      equal to TYPE. For example, it the current version is '1.2.3-beta.1' and the TYPE
      given type is 'alpha', then the command will fail since the new version would sort
      before the existing version (since 'beta' is not <= 'alpha').

      Use --build=BUILD to set the build metadata for the new version (See
      [Build Metadata in the Semantic Versioning Specification](https://semver.org/spec/v2.0.0.html#spec-item-10)).
      If --build is not given, the incremented version retain the previous build
      metadata. Pass an empty string to remove the build metadata (--build="")

      Use --dry-run to run this command without updating the version file.

      Use --quiet to increment the version without producing any output.
      LONG_DESC

      option :'pre-type', type: :string, aliases: '-t', banner: 'TYPE',
                          desc: 'The type of pre-release version (alpha, beta, etc.)'
      option :build, type: :string, aliases: '-b', desc: 'The build metadata to add to the version'
      option :'dry-run', type: :boolean, aliases: '-n', desc: 'Do not write the new version to the version file'
      option :quiet, type: :boolean, aliases: '-q', desc: 'Do not print the new version to stdout'

      # Increment the gem version's pre-release part
      # @param version [String, nil] The version to increment or nil to use the version
      #   from the gem's version file
      # @return [void]
      def next_pre(version = nil)
        args = {}
        args[:pre_type] = options[:'pre-type'] if options[:'pre-type']
        args[:build_metadata] = options[:build] if options[:build]

        new_version = increment_version(:next_pre, args, version)

        puts new_version unless options[:quiet]
      end

      desc 'next-release [VERSION] [-b BUILD] [-n] [-q]', 'Increment a pre-release version to the release version'

      long_desc <<-LONG_DESC
      Increase the current gem version to the next release version, update the
      file that stores the version, and output the resulting version to stdout.

      Increments 1.2.3-rc.4 to 1.2.3.

      The command fails if the current gem version file could not be found or
      the version is not a valid pre-release version.

      If VERSION is given, use that instead of the current gem version. Giving
      VERSION implies --dry-run. The command fails if VERSION is not a valid
      pre-release version.

      Use --build=BUILD to set the build metadata for the new version (See
      [Build Metadata in the Semantic Versioning Specification](https://semver.org/spec/v2.0.0.html#spec-item-10)).
      If --build is not given, the incremented version retain the previous build
      metadata. Pass an empty string to remove the build metadata (--build="")

      Use --dry-run to run this command without updating the version file.

      Use --quiet to increment the version without producing any output.
      LONG_DESC

      option :build, type: :string, aliases: '-b', desc: 'The build metadata to add to the version'
      option :'dry-run', type: :boolean, aliases: '-n', desc: 'Do not write the new version to the version file'
      option :quiet, type: :boolean, aliases: '-q', desc: 'Do not print the new version to stdout'

      # Increment the gem's pre-release version to a release version
      # @param version [String, nil] The version to increment or nil to use the version
      #   from the gem's version file
      # @return [void]
      def next_release(version = nil)
        args = {}
        args[:build_metadata] = options[:build] if options[:build]

        new_version = increment_version(:next_release, args, version)

        puts new_version unless options[:quiet]
      end

      desc 'validate VERSION [-q]', 'Validate the given version'

      long_desc <<-LONG_DESC
      Validate and output the given gem version.

      The command fails if the gem version is not valid.

      Use `--quiet` to validate the gem version without producing any output.
      LONG_DESC

      option :quiet, type: :boolean, aliases: '-q', desc: 'Do not print the given version to stdout'

      # Validate that the give version is a valid IncrementableSemver version
      # @param version [String] The version to validate
      # @return [void]
      #
      def validate(version)
        Semverify::Gem::IncrementableVersion.new(version)
      rescue Semverify::Error => e
        warn e.message unless options[:quiet]
        exit 1
      else
        puts version unless options[:quiet]
      end

      private

      # Build a hash of arguments to pass to the IncrementableSemver methods
      #
      # These arguments are specificly for the #next_major, #next_minor, and
      # #next_patch method.
      #
      # @return [Hash]
      #
      def core_args
        {}.tap do |args|
          args[:pre] = options[:pre] if options[:pre]
          args[:pre_type] = options[:'pre-type'] if options[:'pre-type']
          args[:build_metadata] = options[:build] if options[:build]
        end
      end

      # Increment the gem's major, minor, or patch version
      #
      # @param method [Symbol] The method to call on the IncrementableSemver object
      # @param version [String, nil] The version to increment or nil to use the version
      #  from the gem's version file
      #
      # @return [Void]
      #
      def increment_core_version(method, version)
        new_version = increment_version(method, core_args, version)

        puts new_version unless options[:quiet]
      end

      # Increment the gem's version
      #
      # @param method [Symbol] The method to call on the IncrementableSemver object
      #
      #   The method can bee one of: :next_major, :next_minor, :next_patch, :next_pre, :next_release
      #
      # @param args [Hash] The arguments to pass to the method
      #
      # @param version [String, nil] The version to increment or nil to use the version
      #
      # @return [Void]
      #
      def increment_version(method, args, version)
        if version
          increment_literal_version(method, args, version)
        else
          increment_gem_version(method, args)
        end
      rescue Semverify::Error => e
        warn e.message unless options[:quiet]
        exit 1
      end

      # Increment a literal version from a string
      #
      # @param method [Symbol] The method to call on the IncrementableSemver object
      # @param args [Hash] The arguments to pass to the method
      # @param version [String] The version to increment
      #
      # @return [Semverify::IncrementableRubyVersion] the incremented version
      # @raise [Semverify::Error] if the version is not a valid IncrementableSemver version
      #
      def increment_literal_version(method, args, version)
        Semverify::Gem::IncrementableVersion.new(version).send(method, **args)
      end

      # Increment the gem's version from the gem's version file
      #
      # @param method [Symbol] The method to call on the IncrementableSemver object
      # @param args [Hash] The arguments to pass to the method
      #
      # @return [Semverify::IncrementableRubyVersion] the incremented version
      # @raise [Semverify::Error] if the version is not a valid IncrementableSemver version
      #
      def increment_gem_version(method, args)
        version_file = Semverify::Gem::VersionFileFactory.find

        if version_file.nil?
          warn 'version file not found or is not valid' unless options[:quiet]
          exit 1
        end

        version_file&.version.send(method, **args).tap do |new_version|
          version_file.version = new_version unless options[:'dry-run']
        end
      end
    end
    # rubocop:enable Metrics/ClassLength
  end
end
