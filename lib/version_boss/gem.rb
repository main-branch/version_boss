# frozen_string_literal: true

module VersionBoss
  # Classes for working with Gem versions
  module Gem; end
end

require_relative 'gem/command_line'
require_relative 'gem/incrementable_version'
require_relative 'gem/regexp'
require_relative 'gem/version_file_factory'
require_relative 'gem/version_file_sources'
require_relative 'gem/version_file'
require_relative 'gem/version'
