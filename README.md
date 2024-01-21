# Semverify

[![Gem Version](https://badge.fury.io/rb/semverify.svg)](https://badge.fury.io/rb/semverify)
[![Documentation](https://img.shields.io/badge/Documentation-Latest-green)](https://rubydoc.info/gems/semverify/)
[![Change Log](https://img.shields.io/badge/CHANGELOG-Latest-green)](https://rubydoc.info/gems/semverify/file/CHANGELOG.md)
[![Build Status](https://github.com/main-branch/semverify/workflows/CI%20Build/badge.svg?branch=main)](https://github.com/main-branch/semverify/actions?query=workflow%3ACI%20Build)
[![Maintainability](https://api.codeclimate.com/v1/badges/44a42ed085fe162e5dff/maintainability)](https://codeclimate.com/github/main-branch/semverify/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/44a42ed085fe162e5dff/test_coverage)](https://codeclimate.com/github/main-branch/semverify/test_coverage)

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

* [Installation](#installation)
* [Command Line](#command-line)
  * [Usage](#usage)
  * [Examples](#examples)
* [Library Usage](#library-usage)
* [Development](#development)
* [Contributing](#contributing)
* [License](#license)

## Installation

Install the gem and add to the application's Gemfile by executing:

```shell
bundle add semverify
```

If bundler is not being used to manage dependencies, install the gem by executing:

```shell
gem install semverify
```

## Command Line

### Usage

The `semverify` command line has built in help for all its commands. List the
commands by invoking `semverify` with no arguments or `semverify help` as
follows:

```shell
semverify help
```

The output is the following:

```shell
Commands:
  semverify current [-q]                                              # Show the current gem version
  semverify file [-q]                                                 # Show the path to the file containing the g...
  semverify help [COMMAND]                                            # Describe available commands or one specifi...
  semverify next-major [VERSION] [-p [-t TYPE]] [-b BUILD] [-n] [-q]  # Increment the version's major part
  semverify next-minor [VERSION] [-p [-t TYPE]] [-b BUILD] [-n] [-q]  # Increment the version's minor part
  semverify next-patch [VERSION] [-p [-t TYPE]] [-b BUILD] [-n] [-q]  # Increment the version's patch part
  semverify next-pre [VERSION] [-t TYPE] [-b BUILD] [-n] [-q]         # Increment the version's pre-release part
  semverify next-release [VERSION] [-b BUILD] [-n] [-q]               # Increment a pre-release version to the rel...
  semverify validate VERSION [-q]                                     # Validate the given version
$
```

The `semverify help COMMAND` command will give further help for a specific command:

```shell
semverify help current
```

The output is the following:

```shell
Usage:
  semverify current [-q]

Options:
  -q, [--quiet], [--no-quiet]  # Do not print the current version to stdout

Description:
  Output the current gem version from the file that stores the gem version.

  The command fails if the gem version could not be found or is invalid.

  Use `--quiet` to ensure that a gem version could be found and is valid without producing any output.
$
```

### Examples

```Ruby
semverify current # 0.1.0

semverify validate 1.0.0 # exitcode=0
semverify validate bad_version # exitcode=1

semverify patch # 0.1.0 -> 0.1.1
semverify minor # 0.1.1 -> 0.2.0
semverify major # 0.2.0 -> 1.0.0

# Pre-release with default pre-release type
semverify major --pre # 0.1.1 -> 1.0.0.pre.1

# Pre-release with non-default pre-release type
semverify major --pre --pre-type=alpha # 0.1.1 -> 2.0.0-alpha.1

# Increment pre-release
semverify pre # 1.0.0-alpha.1 -> 1.0.0-alpha.2

# Change the pre-release type
semverify pre --pre-type=beta # 1.0.0-alpha.2 -> 1.0.0-beta.1

# Create release from pre-release
semverify release # 1.0.0-beta.1 -> 1.0.0
```

## Library Usage

[Detailed API documenation](https://rubydoc.info/gems/semverify/) is hosted on rubygems.org.

The main classes are:

* **Semverify::Semver**: Parse and compare generic semver version strings. See
  [semver.org](https://semver.org) for details on what makes a valid semver string.

* **Semverify::IncrementableSemver**: Extends the Semverify::Semver class that knows
  how to increment (aka bump) parts of the version string (major, minor, patch,
  pre-release). Some additional restrictions are put onto the pre-release part
  so that the pre-release part of the version can be incremented.

* **Semverify::VersionFileFactory**: find the gem's version file and returns a
  **Semverify::VersionFile** that knows it's path, the contained version, and how to update
  the version file with a new version.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/main-branch/semverify.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
