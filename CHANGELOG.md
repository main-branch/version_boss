## v0.2.0 (2024-10-10)

[Full Changelog](https://github.com/main-branch/version_boss/compare/v0.1.0..v0.2.0)

Changes since v0.1.0:

* 777871d chore: update create_github_release dependency
* 8225040 build: remove semver pr label check
* 3853ff7 build: enforce conventional commit message formatting
* 3c08516 Clarify gem description and installation instructions
* 012f717 Add TargetRubyVersion in .rubocop.yml
* 4065647 Use shared Rubocop config
* 1dc115f Update copyright notice in this project
* 4a3f092 Update links in gemspec
* a4475f2 Add Slack badge for this project in README
* 28234d4 Update “Build Status” link the README
* e5b59d7 Standardize YARD and Markdown Lint configurations
* aa5851a Set JRuby —debug option when running tests in GitHub Actions workflows
* 3869e9c Integrate SimpleCov::RSpec into the project
* 4fe44a8 Use latest version of create_github_release
* a6ae0af Update continuous integration and experimental ruby builds
* 44ea99f Enforce the use of semver tags on PRs
* baabc32 Auto correct new rubocop offenses
* 8f74384 Release v0.1.0

## [0.2.1](https://github.com/main-branch/version_boss/compare/v0.2.0...v0.2.1) (2025-04-16)


### Bug Fixes

* Automate commit-to-publish workflow ([be256ae](https://github.com/main-branch/version_boss/commit/be256ae4dfdf051fcaaf760113011859806a6ccb))

## v0.1.0 (2024-05-07)

[Full Changelog](https://github.com/main-branch/version_boss/compare/26b5491..v0.1.0)

Changes:

* f802a44 Set initial version number
* f43d795 Create prerelease without dot like "1.0.0.pre1" instead of "1.0.0.pre.1"
* 7ba673a Rename the script 'gem-version' to 'gem-version-boss'
* 16dfc48 Fix YARD in Rakefile and coverage
* 53a6e1b Remove build_metadata from Gem versions (#36)
* 0ecd483 Update Code Climate ID after renaming the repository (#35)
* f83acac Update Code Climate ID after renaming the repository (#34)
* b8b78dc Rename the gem from semverify to version_boss (#32)
* 3d14540 Update README.md for the Semverify::Gem class (#31)
* 562bac9 Remove the "sig" directory from Git (#30)
* 5d0c857 Separate gem code and semver code into their own modules (#29)
* 4c85840 Add Gem version functionality (#27)
* 7404b15 Release v0.3.4
* cf1dd7c Add env coverage options to use when running rspec (#25)
* 4e5cc25 Add command line examples to the README.md (#24)
* 46323a8 Release v0.3.3
* 8219bf1 Remove markdown from gemspec description (#21)
* 7c1585b Release v0.3.2
* 91c3780 Update README and gemspec introduction text (#19)
* 0d584a8 Release v0.3.1
* 51f649f Add Ruby 3.3 to CI build (#17)
* 3255436 Update rubocop configuration for new Rubocop changes (#15)
* 4cbeb23 Release v0.3.0
* 83cf403 Update CodeClimate badges after project rename (#13)
* 7079244 Rename gem from 'semversion' to 'semverify' (#11)
* 64ae102 Release v0.2.0
* 7a8069c Integrate the create_github_release gem (#9)
* 96cdae4 Add Library Usage documentation to README.md (#8)
* 8196c2e Add JRuby Linux and Windows builds to CI builds (#7)
* e6b0739 Add windows build to CI builds (#6)
* 59e310f Fix reported CodeClimate complexity issues (#3)
* 2d28b30 Integrate CodeClimate maintainability and test coverage tracking (#1)
* 2bda849 Add CODEOWNERS file to indicate who can review PRs
* 4599554 Add the CommandLine class and semversion script
* 6204835 Add the #next_release method to IncrementableSemver
* 4219c88 Add the #next_pre method to IncrementableSemver
* 6f3bd22 Add the #next_major, #next_minor, #next_patch methods to IncrementableSemver
* 76782ac Add the IncrementableSemver class
* 98d12cc Add the VersionFile and the VersionFileFactory classes
* 713fddd Add the Semver class
* e5c9864 Update README.md
* 26b5491 Initial version

## v0.3.4 (2024-01-20)

[Full Changelog](https://github.com/main-branch/semverify/compare/v0.3.3..v0.3.4)

Changes since v0.3.3:

* cf1dd7c Add env coverage options to use when running rspec (#25)
* 4e5cc25 Add command line examples to the README.md (#24)

## v0.3.3 (2024-01-11)

[Full Changelog](https://github.com/main-branch/semverify/compare/v0.3.2..v0.3.3)

Changes since v0.3.2:

* 8219bf1 Remove markdown from gemspec description (#21)

## v0.3.2 (2024-01-11)

[Full Changelog](https://github.com/main-branch/semverify/compare/v0.3.1..v0.3.2)

Changes since v0.3.1:

* 91c3780 Update README and gemspec introduction text (#19)

## v0.3.1 (2024-01-05)

[Full Changelog](https://github.com/main-branch/semverify/compare/v0.3.0..v0.3.1)

Changes since v0.3.0:

* 51f649f Add Ruby 3.3 to CI build (#17)
* 3255436 Update rubocop configuration for new Rubocop changes (#15)

## v0.3.0 (2023-03-19)

[Full Changelog](https://github.com/main-branch/semverify/compare/v0.2.0..v0.3.0)

Changes since v0.2.0:

* 83cf403 Update CodeClimate badges after project rename (#13)
* 7079244 Rename gem from 'semversion' to 'semverify' (#11)

## v0.2.0 (2023-03-18)

[Full Changelog](https://github.com/main-branch/semverify/compare/v0.1.0..v0.2.0)

Changes since v0.1.0:

* 7a8069c Integrate the create_github_release gem (#9)
* 96cdae4 Add Library Usage documentation to README.md (#8)
* 8196c2e Add JRuby Linux and Windows builds to CI builds (#7)
* e6b0739 Add windows build to CI builds (#6)
* 59e310f Fix reported CodeClimate complexity issues (#3)
* 2d28b30 Integrate CodeClimate maintainability and test coverage tracking (#1)
* 2bda849 Add CODEOWNERS file to indicate who can review PRs
* 4599554 Add the CommandLine class and semverify script
* 6204835 Add the #next_release method to IncrementableSemver
* 4219c88 Add the #next_pre method to IncrementableSemver
* 6f3bd22 Add the #next_major, #next_minor, #next_patch methods to IncrementableSemver
* 76782ac Add the IncrementableSemver class
* 98d12cc Add the VersionFile and the VersionFileFactory classes
* 713fddd Add the Semver class
* e5c9864 Update README.md

## [Unreleased]

## [0.1.0] - 2023-03-10

- Initial release
