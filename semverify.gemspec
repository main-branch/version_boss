# frozen_string_literal: true

require_relative 'lib/semverify/version'

Gem::Specification.new do |spec|
  spec.name = 'semverify'
  spec.version = Semverify::VERSION
  spec.authors = ['James Couball']
  spec.email = ['jcouball@yahoo.com']

  spec.summary = 'A Gem to parse and compare SemVer versions AND increment versions for Ruby Gems'
  spec.description = <<~DESC
    Parse, compare, and increment RubyGem versions.

    This gem installs the `semverify` CLI tool to display and increment a gem's version
    based on SemVer rules. This tool can replace the `bump` command from the
    [bump gem](https://rubygems.org/gems/bump/) for incrementing gem version strings.

    This gem also provides the `Semverify::Semver` class which knows how to parse,
    validate, and compare [SemVer 2.0.0](https://semver.org/spec/v2.0.0.html) version
    strings.

    Both the CLI tool and the library code support prerelease versions and versions
    with build metadata.

    Example CLI commands:

    ```bash
    # Increment the gem version
    semverify {next-major|next-minor|next-patch} [--pre [--pretype=TYPE]] [--build=METADATA] [--dryrun]
    semverify next-pre [--pretype=TYPE] [--build=METADATA] [--dryrun]
    semverify next-release [--build=METADATA] [--dryrun]

    # Command to display the current gem version
    semverify current

    # Display the gem version file
    semverify file

    # Validate that a version conforms to SemVer 2.0.0
    semverify validate VERSION

    # Get more detailed help for each command listed above
    semverify help [COMMAND]
    ```
  DESC

  spec.homepage = 'http://github.com/main-branch/semverify'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 3.0.0'

  spec.metadata['allowed_push_host'] = 'https://rubygems.org'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['changelog_uri'] = "https://rubydoc.info/gems/#{spec.name}/#{spec.version}/file/CHANGELOG.md"
  spec.metadata['documentation_uri'] = "https://rubydoc.info/gems/#{spec.name}/#{spec.version}"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|circleci)|appveyor)})
    end
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'thor', '~> 1.3'

  spec.add_development_dependency 'bundler-audit', '~> 0.9'
  spec.add_development_dependency 'create_github_release', '~> 1.3'
  spec.add_development_dependency 'rake', '~> 13.1'
  spec.add_development_dependency 'rspec', '~> 3.12'
  spec.add_development_dependency 'rubocop', '~> 1.59'
  spec.add_development_dependency 'simplecov', '~> 0.22'
  spec.add_development_dependency 'simplecov-lcov', '~> 0.8'

  unless RUBY_PLATFORM == 'java'
    spec.add_development_dependency 'redcarpet', '~> 3.6'
    spec.add_development_dependency 'yard', '~> 0.9', '>= 0.9.28'
    spec.add_development_dependency 'yardstick', '~> 0.9'
  end

  spec.metadata['rubygems_mfa_required'] = 'true'
end
