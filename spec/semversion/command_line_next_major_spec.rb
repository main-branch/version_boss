# frozen_string_literal: true

require 'tmpdir'

RSpec.describe Semverify::CommandLine do
  context '#next_major' do
    it_behaves_like 'Gem Core Version Incrementer', :major, '1.2.3', '2.0.0'
  end
end
