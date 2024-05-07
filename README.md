# Version Boss

[![Gem Version](https://badge.fury.io/rb/version_boss.svg)](https://badge.fury.io/rb/version_boss)
[![Documentation](https://img.shields.io/badge/Documentation-Latest-green)](https://rubydoc.info/gems/version_boss/)
[![Change Log](https://img.shields.io/badge/CHANGELOG-Latest-green)](https://rubydoc.info/gems/version_boss/file/CHANGELOG.md)
[![Build Status](https://github.com/main-branch/version_boss/workflows/CI%20Build/badge.svg?branch=main)](https://github.com/main-branch/version_boss/actions?query=workflow%3ACI%20Build)
[![Maintainability](https://api.codeclimate.com/v1/badges/44a42ed085fe162e5dff/maintainability)](https://codeclimate.com/github/main-branch/version_boss/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/44a42ed085fe162e5dff/test_coverage)](https://codeclimate.com/github/main-branch/version_boss/test_coverage)

Parse, compare, and increment Gem and Semver versions.

This gem installs the `gem-version-boss` CLI tool to display and increment a gem's version
based on SemVer rules.

`gem-version-boss` can replace the `bump` command from the [bump
gem](https://rubygems.org/gems/bump/) for incrementing gem version strings.

How `gem-version-boss` differs from `bump`:

* `gem-version-boss` can manage pre-release versions
* `bump` can commit and tag the version file changes it makes. There is no plan to
  add this functionality to `gem-version-boss`.
* `bump` can update the version in extra files you to specify extra files to
  increment the version in

Example CLI commands:

```shell
# Increment the gem version
gem-version-boss {next-major|next-minor|next-patch} [--pre [--pretype=TYPE]] [--dryrun]
gem-version-boss next-pre [--pretype=TYPE] [--dryrun]
gem-version-boss next-release [--dryrun]

# Command to display the current gem version
gem-version-boss current

# Display the gem version file
gem-version-boss file

# Validate that a version conforms to SemVer 2.0.0
gem-version-boss validate VERSION

# Get more detailed help for each command listed above
gem-version-boss help [COMMAND]
```

* [Installation](#installation)
* [Command Line](#command-line)
  * [Usage](#usage)
  * [Examples](#examples)
* [Library Usage](#library-usage)
  * [VersionBoss::Gem classes](#versionbossgem-classes)
  * [VersionBoss::Semver classes](#versionbosssemver-classes)
* [Development](#development)
* [Contributing](#contributing)
* [License](#license)

## Installation

Install the gem and add to the application's Gemfile by executing:

```shell
bundle add version_boss
```

If bundler is not being used to manage dependencies, install the gem by executing:

```shell
gem install version_boss --group=development
```

## Command Line

### Usage

The `gem-version-boss` command line has built in help for all its commands. List the
commands by invoking `gem-version-boss` with no arguments or `gem-version-boss help` as
follows:

```shell
gem-version-boss help
```

The output is the following:

```shell
Commands:
  gem-version-boss current [-q]                                   # Show the current gem version
  gem-version-boss file [-q]                                      # Show the path to the file containing the gem version
  gem-version-boss help [COMMAND]                                 # Describe available commands or one specific command
  gem-version-boss next-major [VERSION] [-p [-t TYPE]] [-n] [-q]  # Increment the version's major part
  gem-version-boss next-minor [VERSION] [-p [-t TYPE]] [-n] [-q]  # Increment the version's minor part
  gem-version-boss next-patch [VERSION] [-p [-t TYPE]] [-n] [-q]  # Increment the version's patch part
  gem-version-boss next-pre [VERSION] [-t TYPE] [-n] [-q]         # Increment the version's pre-release part
  gem-version-boss next-release [VERSION] [-n] [-q]               # Increment a pre-release version to the release version
  gem-version-boss validate VERSION [-q]                          # Validate the given version
```

The `gem-version-boss help COMMAND` command will give further help for a specific command:

```shell
gem-version-boss help current
```

The output is the following:

```shell
Usage:
  gem-version-boss current [-q]

Options:
  -q, [--quiet], [--no-quiet], [--skip-quiet]  # Do not print the current version to stdout

Description:
  Output the current gem version from the file that stores the gem version.

  The command fails if the gem version could not be found or is invalid.

  Use `--quiet` to ensure that a gem version could be found and is valid without producing any output.
```

### Examples

```shell
gem-version-boss current # 0.1.0

gem-version-boss validate 1.0.0 # exitcode=0
gem-version-boss validate bad_version # exitcode=1

gem-version-boss next-patch # 0.1.0 -> 0.1.1
gem-version-boss next-minor # 0.1.1 -> 0.2.0
gem-version-boss next-major # 0.2.0 -> 1.0.0

# Pre-release with default pre-release type
gem-version-boss next-major --pre # 0.1.1 -> 1.0.0.pre1

# Pre-release with non-default pre-release type
gem-version-boss next-major --pre --pre-type=alpha # 0.1.1 -> 2.0.0-alpha1

# Increment pre-release
gem-version-boss next-pre # 1.0.0-alpha1 -> 1.0.0-alpha2

# Change the pre-release type
gem-version-boss pre --pre-type=beta # 1.0.0-alpha2 -> 1.0.0-beta1

# Create release from pre-release
gem-version-boss release # 1.0.0-beta1 -> 1.0.0
```

This gem also provides the following classes:

## Library Usage

[Detailed API documenation](https://rubydoc.info/gems/version_boss/) is hosted on
rubygems.org.

The main classes are:

### VersionBoss::Gem classes

* **VersionBoss::Gem::Version** knows how to parse, validate, and compare [Ruby Gem
  version strings](https://guides.rubygems.org/patterns/#semantic-versioning).

* **VersionBoss::Gem::IncrementableVersion** knows how to increment Ruby Gem version
  strings according to SemVer rules.

* **VersionBoss::Gem::VersionFileFactory**: find the gem's version file and returns a
  **VersionBoss::Gem::VersionFile** that knows it's path, the contained version, and
  how to update the version file with a new version.

### VersionBoss::Semver classes

* **VersionBoss::Semver::Version** knows how to parse, validate, and compare version
  strings that conform to [SemVer 2.0.0](https://semver.org/spec/v2.0.0.html)

* **VersionBoss::Semver::IncrementableVersion** knows how to increment Semver version
  strings according to SemVer rules.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake
spec` to run the tests. You can also run `bin/console` for an interactive prompt that
will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To
release a new version, update the version number in `version.rb`, and then run
`bundle exec rake release`, which will create a git tag for the version, push git
commits and the created tag, and push the `.gem` file to
[rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/main-branch/version_boss.

## License

The gem is available as open source under the terms of the [MIT
License](https://opensource.org/licenses/MIT).
