# frozen_string_literal: true

require 'semversion/command_line'
require 'semversion/incrementable_semver'
require 'semversion/regexp'
require 'semversion/semver'
require 'semversion/version_file'
require 'semversion/version_file_factory'
require 'semversion/version_file_sources'
require 'semversion/version'

# Parse and compare semver versions AND bump versions for Ruby Gems
module Semversion
  # Errors reported by the Semversion library
  class Error < StandardError; end

  # Your code goes here...
end
