# frozen_string_literal: true

require 'semverify/command_line'
require 'semverify/incrementable_semver'
require 'semverify/regexp'
require 'semverify/semver'
require 'semverify/version_file'
require 'semverify/version_file_factory'
require 'semverify/version_file_sources'
require 'semverify/version'

# Parse and compare semver versions AND bump versions for Ruby Gems
module Semverify
  # Errors reported by the Semverify library
  class Error < StandardError; end

  # Your code goes here...
end
