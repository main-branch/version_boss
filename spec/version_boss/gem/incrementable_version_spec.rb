# frozen_string_literal: true

RSpec.describe VersionBoss::Gem::IncrementableVersion do
  let(:version_object) { described_class.new(version) }

  describe '#initialize' do
    subject { version_object }

    context 'with a version that does not include a pre-release part' do
      let(:version) { '1.2.3' }
      it { is_expected.to be_a(described_class) }
    end

    context 'with a version that has a pre-release part with one identifier' do
      let(:version) { '1.2.3.alpha' }
      it 'is expected to raise an VersionBoss::Error' do
        expect { subject }.to raise_error(VersionBoss::Error)
      end
    end

    context 'with a version that has a pre-release part with two identifiers' do
      let(:version) { '1.2.3.alpha.1' }
      context 'when the first identifier is a String and the second is an Integer' do
        it { is_expected.to be_a(described_class) }
      end

      context 'when either the first identifier is NOT a string or the second is NOT an Integer' do
        let(:version) { '1.2.3.alpha.one' }
        it 'is expected to raise an VersionBoss::Error' do
          expect { subject }.to raise_error(VersionBoss::Error)
        end
      end
    end

    context 'when the version has a pre-release part with more than two identifiers' do
      let(:version) { '1.2.3.alpha.1.2' }
      it 'is expected to raise an VersionBoss::Error' do
        expect { subject }.to raise_error(VersionBoss::Error)
      end
    end
  end

  describe '#next_major' do
    subject { version_object.next_major(**args) }
    let(:args) { {} }

    context 'when the version does not have pre_release or build_metadata parts' do
      context 'when neither pre nor build_metadata args were given' do
        let(:version) { '1.2.3' }
        let(:expected_version) { described_class.new('2.0.0') }
        it { is_expected.to be_a(described_class) }
        it { is_expected.to eq(expected_version) }
      end

      context 'when arg pre: true is given' do
        let(:args) { { pre: true } }
        let(:version) { '1.2.3' }
        let(:expected_version) { described_class.new('2.0.0.pre.1') }
        it 'should increment the major part and set the pre-release part to "pre.1"' do
          expect(subject).to eq(expected_version)
        end
      end

      context "when args pre: true, pre_suffix: 'alpha' are given" do
        let(:args) { { pre: true, pre_type: 'alpha' } }
        let(:version) { '1.2.3' }
        let(:expected_version) { described_class.new('2.0.0.alpha.1') }
        it 'should increment the major part and set the pre-release part to "alpha.1"' do
          expect(subject).to eq(expected_version)
        end
      end
    end

    context 'when the version has a pre-release part' do
      context 'with out any args' do
        let(:version) { '1.2.3.alpha.1' }
        let(:expected_version) { described_class.new('2.0.0') }
        it 'should increment the major part and clear the pre-release part' do
          expect(subject).to eq(expected_version)
        end
      end

      context 'when the arg pre: true is given' do
        let(:args) { { pre: true } }
        let(:version) { '1.2.3.pre.3' }
        let(:expected_version) { described_class.new('2.0.0.pre.1') }
        it "should increment the major part and set pre-release part to 'pre.1'" do
          expect(subject).to eq(expected_version)
        end
      end

      context 'when the args pre: true, pre_type: "alpha" are given' do
        let(:args) { { pre: true, pre_type: 'alpha' } }
        let(:version) { '1.2.3.pre.3' }
        let(:expected_version) { described_class.new('2.0.0.alpha.1') }
        it "should increment the major part and set pre-release part to 'alpha.1'" do
          expect(subject).to eq(expected_version)
        end
      end
    end
  end

  describe '#next_minor' do
    subject { version_object.next_minor(**args) }
    let(:args) { {} }

    context 'when the version does not have pre_release or build_metadata parts' do
      context 'when neither pre nor build_metadata args were given' do
        let(:version) { '1.2.3' }
        let(:expected_version) { described_class.new('1.3.0') }
        it { is_expected.to be_a(described_class) }
        it { is_expected.to eq(expected_version) }
      end

      context 'when arg pre: true is given' do
        let(:args) { { pre: true } }
        let(:version) { '1.2.3' }
        let(:expected_version) { described_class.new('1.3.0.pre.1') }
        it 'should incrementthe minor part and set the pre-release part to "pre.1"' do
          expect(subject).to eq(expected_version)
        end
      end

      context "when args pre: true, pre_suffix: 'alpha' are given" do
        let(:args) { { pre: true, pre_type: 'alpha' } }
        let(:version) { '1.2.3' }
        let(:expected_version) { described_class.new('1.3.0.alpha.1') }
        it 'should increment the minor part and set the pre-release part to "alpha.1"' do
          expect(subject).to eq(expected_version)
        end
      end
    end

    context 'when the version has a pre-release part' do
      context 'with out any args' do
        let(:version) { '1.2.3.alpha.1' }
        let(:expected_version) { described_class.new('1.3.0') }
        it 'should increment the minor part and clear the pre-release part' do
          expect(subject).to eq(expected_version)
        end
      end

      context 'when the arg pre: true is given' do
        let(:args) { { pre: true } }
        let(:version) { '1.2.3.pre.3' }
        let(:expected_version) { described_class.new('1.3.0.pre.1') }
        it "should increment the minor part and set pre-release part to 'pre.1'" do
          expect(subject).to eq(expected_version)
        end
      end

      context 'when the args pre: true, pre_type: "alpha" are given' do
        let(:args) { { pre: true, pre_type: 'alpha' } }
        let(:version) { '1.2.3.pre.3' }
        let(:expected_version) { described_class.new('1.3.0.alpha.1') }
        it "should increment the minor part and set pre-release part to 'alpha.1'" do
          expect(subject).to eq(expected_version)
        end
      end
    end
  end

  describe '#next_pre' do
    subject { version_object.next_pre(**args) }
    let(:args) { {} }

    context 'when the version does not have a pre_release part' do
      let(:version) { '1.2.3' }
      it 'should raise a Seversion::Error because you can not pre increment a release version' do
        expect { subject }.to raise_error(VersionBoss::Error)
      end
    end

    context "when the version has a pre_release part 'beta.1'" do
      let(:version) { '1.2.3.beta.1' }

      context 'when no args are given' do
        it 'should increment the pre-release part to "beta.2"' do
          expect(subject).to eq(described_class.new('1.2.3.beta.2'))
        end
      end

      context 'when pre_type arg is given' do
        context "when the arg { pre_type: 'alpha' } is given" do
          let(:args) { { pre_type: 'alpha' } }
          it 'should raise a Seversion::Error because the pre_type is lexically " \
            "before the existing pre-release part' do
            expect { subject }.to raise_error(VersionBoss::Error)
          end
        end

        context "when the arg { pre_type: 'beta' } is given" do
          let(:args) { { pre_type: 'beta' } }
          it "should increment the pre-release part to 'beta.2'" do
            expect(subject).to eq(described_class.new('1.2.3.beta.2'))
          end
        end

        context "when the arg { pre_type: 'rc' } is given" do
          let(:args) { { pre_type: 'rc' } }
          it "should increment the pre-release part to 'rc.1'" do
            expect(subject).to eq(described_class.new('1.2.3.rc.1'))
          end
        end
      end
    end
  end

  describe '#next_patch' do
    subject { version_object.next_patch(**args) }
    let(:args) { {} }

    context 'when the version does not have pre_release or build_metadata parts' do
      context 'when neither pre nor build_metadata args were given' do
        let(:version) { '1.2.3' }
        let(:expected_version) { described_class.new('1.2.4') }
        it { is_expected.to be_a(described_class) }
        it { is_expected.to eq(expected_version) }
      end

      context 'when arg pre: true is given' do
        let(:args) { { pre: true } }
        let(:version) { '1.2.3' }
        let(:expected_version) { described_class.new('1.2.4.pre.1') }
        it 'should increment the patch part and set the pre-release part to "pre.1"' do
          expect(subject).to eq(expected_version)
        end
      end

      context "when args pre: true, pre_suffix: 'alpha' are given" do
        let(:args) { { pre: true, pre_type: 'alpha' } }
        let(:version) { '1.2.3' }
        let(:expected_version) { described_class.new('1.2.4.alpha.1') }
        it 'should increment the patch part and set the pre-release part to "alpha.1"' do
          expect(subject).to eq(expected_version)
        end
      end
    end

    context 'when the version has a pre-release part' do
      context 'with out any args' do
        let(:version) { '1.2.3.alpha.1' }
        let(:expected_version) { described_class.new('1.2.4') }
        it 'should increment the patch part and clear the pre-release part' do
          expect(subject).to eq(expected_version)
        end
      end

      context 'when the arg pre: true is given' do
        let(:args) { { pre: true } }
        let(:version) { '1.2.3.pre.3' }
        let(:expected_version) { described_class.new('1.2.4.pre.1') }
        it "should increment the patch part and set pre-release part to 'pre.1'" do
          expect(subject).to eq(expected_version)
        end
      end

      context 'when the args pre: true, pre_type: "alpha" are given' do
        let(:args) { { pre: true, pre_type: 'alpha' } }
        let(:version) { '1.2.3.pre.3' }
        let(:expected_version) { described_class.new('1.2.4.alpha.1') }
        it "should increment the patch part and set pre-release part to 'alpha.1'" do
          expect(subject).to eq(expected_version)
        end
      end
    end
  end

  describe '#next_release' do
    subject { version_object.next_release(**args) }
    let(:args) { {} }

    context 'when the version does not have a pre_release part' do
      let(:version) { '1.2.3' }
      it 'should raise a Seversion::Error because you can not release a non.pre-release version' do
        expect { subject }.to raise_error(VersionBoss::Error)
      end
    end

    context 'when the version is a pre-release version' do
      let(:version) { '1.2.3.beta.1' }
      it 'should return a non.pre-release version' do
        expect(subject).to eq(described_class.new('1.2.3'))
      end
    end
  end
end
