# frozen_string_literal: true

require_relative 'semverify/gem'
require_relative 'semverify/semver'

# Parse, compare, and increment versions according to the SemVer 2.0.0
module Semverify
  # Errors reported by the Semverify gem
  class Error < StandardError; end
end
