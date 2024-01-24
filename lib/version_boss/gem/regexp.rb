# frozen_string_literal: true

module VersionBoss
  module Gem
    # Match a gem_version within a string
    REGEXP = /
      (?<gem_version>
        (?<major>0|[1-9]\d*)
        \.
        (?<minor>0|[1-9]\d*)
        \.
        (?<patch>0|[1-9]\d*)
        (?<pre_release>
          (?:
            \.?
            [a-z]+
            (?:
              \.?
              (?:[a-z]+|\d+)
            )*
          )?
        )
      )
    /x

    # Match a gem_version to the full string
    REGEXP_FULL = /\A#{REGEXP.source}\z/x
  end
end
