# frozen_string_literal: true

RSpec.describe Semverify do
  it 'has a version number' do
    expect(Semverify::VERSION).not_to be nil
  end
end
