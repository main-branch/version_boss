# frozen_string_literal: true

require_relative 'version_file_sources/base'
require_relative 'version_file_sources/gemspec'
require_relative 'version_file_sources/version'
require_relative 'version_file_sources/version_rb'

module VersionBoss
  module Gem
    # Module containing version file sources used by VersionBoss::Gem::VersionFileFactory
    module VersionFileSources
    end
  end
end
