# Semversion

[![Gem Version](https://badge.fury.io/rb/semversion.svg)](https://badge.fury.io/rb/semversion)
[![Documentation](https://img.shields.io/badge/Documentation-Latest-green)](https://rubydoc.info/gems/semversion/)
[![Change Log](https://img.shields.io/badge/CHANGELOG-Latest-green)](https://rubydoc.info/gems/semversion/file/CHANGELOG.md)
[![Build Status](https://github.com/main-branch/semversion/workflows/CI%20Build/badge.svg?branch=main)](https://github.com/main-branch/semversion/actions?query=workflow%3ACI%20Build)
[![Maintainability](https://api.codeclimate.com/v1/badges/836982cfce050461dc99/maintainability)](https://codeclimate.com/github/main-branch/semversion/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/836982cfce050461dc99/test_coverage)](https://codeclimate.com/github/main-branch/semversion/test_coverage)

A Gem to parse, compare, and increment versions for RubyGems.

Can be used as an alternative to the [bump RubyGem](https://rubygems.org/gems/bump/).

* [Semversion](#semversion)
  * [Installation](#installation)
  * [Command Line Usage](#command-line-usage)
  * [Library Usage](#library-usage)
  * [Development](#development)
  * [Contributing](#contributing)
  * [License](#license)

## Installation

Install the gem and add to the application's Gemfile by executing:

```shell
bundle add UPDATE_WITH_YOUR_GEM_NAME_PRIOR_TO_RELEASE_TO_RUBYGEMS_ORG
```

If bundler is not being used to manage dependencies, install the gem by executing:

```shell
gem install UPDATE_WITH_YOUR_GEM_NAME_PRIOR_TO_RELEASE_TO_RUBYGEMS_ORG
```

## Command Line Usage

The `semversion` command line has built in help for all its commands. List the
commands by invoking `semversion` with no arguments or `semversion help` as
follows:

```shell
semversion help
```

The output is the following:

```shell
Commands:
  semversion current [-q]                                              # Show the current gem version
  semversion file [-q]                                                 # Show the path to the file containing the g...
  semversion help [COMMAND]                                            # Describe available commands or one specifi...
  semversion next-major [VERSION] [-p [-t TYPE]] [-b BUILD] [-n] [-q]  # Increment the version's major part
  semversion next-minor [VERSION] [-p [-t TYPE]] [-b BUILD] [-n] [-q]  # Increment the version's minor part
  semversion next-patch [VERSION] [-p [-t TYPE]] [-b BUILD] [-n] [-q]  # Increment the version's patch part
  semversion next-pre [VERSION] [-t TYPE] [-b BUILD] [-n] [-q]         # Increment the version's pre-release part
  semversion next-release [VERSION] [-b BUILD] [-n] [-q]               # Increment a pre-release version to the rel...
  semversion validate VERSION [-q]                                     # Validate the given version
$
```

The `semversion help COMMAND` command will give further help for a specific command:

```shell
semversion help current
```

The output is the following:

```shell
Usage:
  semversion current [-q]

Options:
  -q, [--quiet], [--no-quiet]  # Do not print the current version to stdout

Description:
  Output the current gem version from the file that stores the gem version.

  The command fails if the gem version could not be found or is invalid.

  Use `--quiet` to ensure that a gem version could be found and is valid without producing any output.
$
```

## Library Usage

[Detailed API documenation](https://rubydoc.info/gems/semversion/) is hosted on rubygems.org.

The main classes are:

* **Semversion::Semver**: Parse and compare generic semver version strings. See
  [semver.org](https://semver.org) for details on what makes a valid semver string.

* **Semversion::IncrementableSemver**: Extends the Semversion::Semver class that knows
  how to increment (aka bump) parts of the version string (major, minor, patch,
  pre-release). Some additional restrictions are put onto the pre-release part
  so that the pre-release part of the version can be incremented.

* **Semversion::VersionFileFactory**: find the gem's version file and returns a
  **Semversion::VersionFile** that knows it's path, the contained version, and how to update
  the version file with a new version.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/main-branch/semversion.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
