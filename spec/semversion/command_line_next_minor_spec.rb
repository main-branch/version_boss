# frozen_string_literal: true

require 'tmpdir'

RSpec.describe Semversion::CommandLine do
  context '#next_minor' do
    it_behaves_like 'Core Version Incrementer', :minor, '1.2.3', '1.3.0'
  end
end
