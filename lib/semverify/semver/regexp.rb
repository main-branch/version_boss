# frozen_string_literal: true

module Semverify
  module Semver
    # Match a semver within a string
    REGEXP = /
      (?<semver>
        (?<major>0|[1-9]\d*)
        \.
        (?<minor>0|[1-9]\d*)
        \.
        (?<patch>0|[1-9]\d*)
        (?:-
          (?<pre_release>
            (?:
              0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*
            )
            (?:
              \.
              (?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*)
            )*
          )
        )?
        (?:
          \+
          (?<build_metadata>
            [0-9a-zA-Z-]+
            (?:
              \.
              [0-9a-zA-Z-]+
            )*
          )
        )?
      )
    /x

    # Match a semver to the full string
    REGEXP_FULL = /\A#{REGEXP.source}\z/x
  end
end
