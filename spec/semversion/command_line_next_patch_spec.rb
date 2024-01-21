# frozen_string_literal: true

require 'tmpdir'

RSpec.describe Semverify::CommandLine do
  context '#next_patch' do
    it_behaves_like 'Gem Core Version Incrementer', :patch, '1.2.3', '1.2.4'
  end
end
