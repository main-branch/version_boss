# Semversion

A Gem to parse and compare semver versions AND bump versions for Ruby Gems.

* [Semversion](#semversion)
  * [Installation](#installation)
  * [Command Line Usage](#command-line-usage)
    * [current](#current)
    * [file](#file)
    * [validate](#validate)
    * [bump](#bump)
    * [set](#set)
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

### current

`semver current [--quiet]`

Validate and output the current gem version.

The command fails if the current gem version is not valid.

Use `--quiet` to validate the current gem version without producing any output.

### file

`semver file [--quiet]`

Output the relative path to the file that store the gem version.

The command fails if the gem version could not be found.

Use `--quiet` to ensure that a gem version could be found without producing any output.

### validate

`semver validate VERSION [--quiet]`

Validate and output `VERSION`.

Use `--quiet` to validate `VERSION` without producing any output.

The command fails if `VERSION` is not valid.

### bump

```shell
semversion bump {major|minor|patch|pre|release} [VERSION] \
[--pre] [--pre-prefix=PREFIX] [--build=BUILD] [--quiet] [--dry-run]
```

Increase the current gem version, update the file that stores the version, and
output the resulting version.

The command fails if the current gem version is not valid.

If `VERSION` is given, use that instead of the current gem version.
Giving `VERSION` implies `--dry-run`. The command fails if `VERSION` is not valid.

`major`, `minor`, `patch`, `pre`, and `release` determines how the version is
incremented.

* `major` increments `1.x.y` to `2.0.0`.
* `minor` increments `1.2.x` to `1.3.0`.
* `patch` increments `1.2.3` to `1.2.4`
* `pre` increments `1.2.3-pre.1` to `1.2.3-pre.2`.
* `release` drops the pre-release part of the version. Increments `1.2.3-pre.1` to `1.2.3`.

By default, the pre-release prefix is `pre`. Use `--pre-prefix=PREFIX` to use
`PREFIX` instead (like `alpha`, `beta`, `rc`, etc.).

If both `pre` and `--pre-prefix=PREFIX` are given AND the current version already
has a pre-release part where the pre-release prefix does not match the given `PREFIX`,
then the pre-release number is reset to 1. For example, `semversion pre --pre-prefix=beta`
will increment `1.2.3-alpha.3` to `1.2.3-beta.1`.

The command fails if the existing pre-release prefix is not lexically less than or
equal to `PREFIX`.

The command fails if `pre` is given and either the current version does not
already have a pre-relaese part OR `--pre-prefix` is not also given.

`--pre` can be used with `major`, `minor`, and `patch` to specify that the version
should be incremented AND given a pre-release part. For instance, `semversion major --pre`
increments `1.2.3` to `2.0.0-pre.1`.

`--pre-prefix` can be used with `--pre` to specify a different pre-release prefix. For
instance, `semversion major --pre --pre-prefix=alpha`  increments `1.2.3` to
`2.0.0-alpha.1`.

The command fails if `release` is given and the version does not have a pre-release
part.

Use `--build=BUILD` to set the build metadata for the new version (See
[Build Metadata in the Semantic Versioning Specification](https://semver.org/spec/v2.0.0.html#spec-item-10)).
If `--build` is not given, the incremented version will not include build metadata.

Use `--quiet` to increment the version without producing any output.

Use `--dry-run` to run this command without updating the version file.

### set

```shell
semversion set VERSION [--quiet]
```

Update the file that stores the version and output the version.

The command fails if `VERSION` is not valid.

Use `--quiet` to increment the version without producing any output.

## Library Usage

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/main-branch/semversion.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
