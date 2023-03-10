# Semversion

A Gem to parse and compare semver versions AND bump versions for Ruby Gems.

* [Semversion](#semversion)
  * [Installation](#installation)
  * [Usage](#usage)
    * [Rake Tasks](#rake-tasks)
      * [semversion:current](#semversioncurrent)
      * [semversion:file](#semversionfile)
      * [semversion:bump\_major](#semversionbump_major)
      * [semversion:bump\_minor](#semversionbump_minor)
      * [semversion:bump\_patch](#semversionbump_patch)
      * [semversion:bump\_pre\_release](#semversionbump_pre_release)
      * [semversion:bump\_release](#semversionbump_release)
    * [Command Line](#command-line)
      * [semver current](#semver-current)
      * [semver file](#semver-file)
      * [semver bump-major](#semver-bump-major)
      * [semver bump-minor](#semver-bump-minor)
      * [semver bump patch](#semver-bump-patch)
      * [semver bump pre](#semver-bump-pre)
      * [semver bump release](#semver-bump-release)
    * [Library](#library)
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

## Usage

### Rake Tasks

#### semversion:current

#### semversion:file

#### semversion:bump_major

#### semversion:bump_minor

#### semversion:bump_patch

#### semversion:bump_pre_release

#### semversion:bump_release

### Command Line

#### semver current

```shell
semver current [VERSION]
```

If `VERSION` is not given, the version will be found in the current gem's source code.

Validates and outputs the version.

#### semver file

```shell
semver file
```

Show the relative path to the file containing the current gem version AND the type of file.

#### semver bump-major

```shell
semver bump-major [VERSION] [--build=BUILD]
```

#### semver bump-minor

```shell
semver bump-minor [VERSION] [--build=BUILD]
```

#### semver bump patch

```shell
semver bump-patch [VERSION] [--build=BUILD]
```

#### semver bump pre

```shell
semver bump-pre [VERSION] [--prefix=PREFIX] [--build=BUILD]
```

#### semver bump release

```shell
semver bump-release [VERSION] [--build=BUILD] [--dry-run|-n] [--quiet|-q]
```

### Library

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/main-branch/semversion.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
