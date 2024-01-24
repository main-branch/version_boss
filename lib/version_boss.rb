# frozen_string_literal: true

require_relative 'version_boss/gem'
require_relative 'version_boss/semver'

# Parse, compare, and increment versions according to the SemVer 2.0.0
module VersionBoss
  # Errors reported by the VersionBoss gem
  class Error < StandardError; end
end
