# frozen_string_literal: true

RSpec.describe Semversion::IncrementableSemver do
  let(:version_object) { described_class.new(version) }

  describe '#initialize' do
    subject { version_object }

    context 'with a version that does not include a pre-release part' do
      let(:version) { '1.2.3' }
      it { is_expected.to be_a(described_class) }
    end

    context 'with a version that has a pre-release part with one identifier' do
      let(:version) { '1.2.3-alpha' }
      it 'is expected to raise an ArgumentError' do
        expect { subject }.to raise_error(ArgumentError)
      end
    end

    context 'with a version that has a pre-release part with two identifiers' do
      let(:version) { '1.2.3-alpha.1' }
      context 'when the first identifier is a String and the second is an Integer' do
        it { is_expected.to be_a(described_class) }
      end

      context 'when either the first identifier is NOT a string or the second is NOT an Integer' do
        let(:version) { '1.2.3-alpha.one' }
        it 'is expected to raise an ArgumentError' do
          expect { subject }.to raise_error(ArgumentError)
        end
      end
    end

    context 'when the version has a pre-release part with more than two identifiers' do
      let(:version) { '1.2.3-alpha.1.2' }
      it 'is expected to raise an ArgumentError' do
        expect { subject }.to raise_error(ArgumentError)
      end
    end
  end
end
