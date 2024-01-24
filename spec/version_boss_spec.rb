# frozen_string_literal: true

RSpec.describe VersionBoss do
  it 'has a version number' do
    expect(VersionBoss::VERSION).not_to be nil
  end
end
