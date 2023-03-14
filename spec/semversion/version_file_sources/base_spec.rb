# frozen_string_literal: true

RSpec.describe Semversion::VersionFileSources::Base do
  describe '#glob' do
    it 'should raise a NotImplementedError' do
      expect { described_class.send(:glob) }.to raise_error(NotImplementedError)
    end
  end

  describe '#content_regexp' do
    it 'should raise a NotImplementedError' do
      expect { described_class.send(:content_regexp) }.to raise_error(NotImplementedError)
    end
  end
end
