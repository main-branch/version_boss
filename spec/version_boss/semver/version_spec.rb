# frozen_string_literal: true

RSpec.describe VersionBoss::Semver::Version do
  describe '#initialize' do
    subject { described_class.new(version) }

    context 'when version is not a string' do
      let(:version) { 1 }
      it 'should raise an VersionBoss::Error' do
        expect { subject }.to raise_error(VersionBoss::Error)
      end
    end

    context 'with an invalid version' do
      let(:version) { 'asdf' }
      it 'should raise an VersionBoss::Error' do
        expect { subject }.to raise_error(VersionBoss::Error)
      end
    end

    context 'with a partial version' do
      let(:version) { '1.2' }
      it 'should raise an VersionBoss::Error' do
        expect { subject }.to raise_error(VersionBoss::Error)
      end
    end

    context 'with version 1.2.3' do
      let(:version) { '1.2.3' }
      it do
        is_expected.to(
          have_attributes(
            major: '1',
            minor: '2',
            patch: '3',
            pre_release: '',
            build_metadata: ''
          )
        )
      end
    end

    context 'with a version that includes a pre-release part' do
      let(:version) { '1.2.3-pre.1' }
      it do
        is_expected.to(
          have_attributes(
            major: '1',
            minor: '2',
            patch: '3',
            pre_release: 'pre.1',
            build_metadata: ''
          )
        )
      end
    end

    context 'with a version that includes a pre-release consisting of a single numeric field' do
      let(:version) { '1.2.3-1' }
      it do
        is_expected.to(
          have_attributes(
            major: '1',
            minor: '2',
            patch: '3',
            pre_release: '1',
            build_metadata: ''
          )
        )
      end
    end

    context 'with a version that includes a build metadata part' do
      let(:version) { '1.2.3-pre.1+build.001' }
      it do
        is_expected.to(
          have_attributes(
            major: '1',
            minor: '2',
            patch: '3',
            pre_release: 'pre.1',
            build_metadata: 'build.001'
          )
        )
      end
    end
  end

  describe '<=>' do
    let(:semver_version) { described_class.new(version) }
    let(:other_semver_version) { described_class.new(other_version) }

    context 'with simple versions consisting of only major, minor, and patch parts' do
      context 'with two versions that differ only by the major part (1.0.0 < 2.0.0)' do
        let(:version) { '1.0.0' }
        let(:other_version) { '2.0.0' }
        it 'should sort the lesser version first' do
          expect(semver_version <=> other_semver_version).to eq(-1)
          expect(other_semver_version <=> semver_version).to eq(1)
        end
      end
      context 'with two versions that differ only by the minor part (0.1.0 < 0.2.0)' do
        let(:version) { '0.1.0' }
        let(:other_version) { '0.2.0' }
        it 'should sort the lesser version first' do
          expect(semver_version <=> other_semver_version).to eq(-1)
          expect(other_semver_version <=> semver_version).to eq(1)
        end
      end

      context 'with two versions that differ only by the patch part (0.0.1 < 0.0.1)' do
        let(:version) { '0.0.1' }
        let(:other_version) { '0.0.2' }
        it 'should sort the lesser version first' do
          expect(semver_version <=> other_semver_version).to eq(-1)
          expect(other_semver_version <=> semver_version).to eq(1)
        end
      end

      context 'version parts should be compared numerically (9.0.0 < 10.0.0)' do
        let(:version) { '9.0.0' }
        let(:other_version) { '10.0.0' }
        it 'should sort the lesser version first' do
          expect(semver_version <=> other_semver_version).to eq(-1)
          expect(other_semver_version <=> semver_version).to eq(1)
        end
      end

      context 'with two versions whose parts are all equal (1.0.0 == 1.0.0)' do
        let(:version) { '1.0.0' }
        let(:other_version) { '1.0.0' }
        it 'should indicate they are equal' do
          expect(semver_version <=> other_semver_version).to eq(0)
        end
      end
    end

    context 'with pre-release versions' do
      context 'with versions where major, minor, or patch parts differ (1.0.0 < 2.0.0-pre.1)' do
        let(:version) { '1.0.0' }
        let(:other_version) { '2.0.0-pre.1' }
        it 'should sort by the major, minor, and patch parts only' do
          expect(semver_version <=> other_semver_version).to eq(-1)
          expect(other_semver_version <=> semver_version).to eq(1)
        end
      end

      context 'with versions that are equal except one has a pre-release part (1.0.0-pre.1 < 1.0.0)' do
        let(:version) { '1.0.0-pre.1' }
        let(:other_version) { '1.0.0' }
        it 'should sort the version with the pre-relase part before the other version' do
          expect(semver_version <=> other_semver_version).to eq(-1)
          expect(other_semver_version <=> semver_version).to eq(1)
        end
      end

      context 'with versions that both have pre-release parts' do
        context 'when the pre-release parts are the same (1.0.0-pre.1 = 1.0.0-pre.1)' do
          let(:version) { '1.0.0-pre.1' }
          let(:other_version) { '1.0.0-pre.1' }
          it 'should indicate the versions are equal' do
            expect(semver_version <=> other_semver_version).to eq(0)
          end
        end

        context 'when the pre-release parts differ in number of identifiers (1.0.0-alpha < 1.0.0-alpha.1)' do
          let(:version) { '1.0.0-alpha' }
          let(:other_version) { '1.0.0-alpha.1' }
          it 'should sort the version with the fewer identifiers before the other version' do
            expect(semver_version <=> other_semver_version).to eq(-1)
            expect(other_semver_version <=> semver_version).to eq(1)
          end
        end

        context 'when the pre-release parts both have numerical identifiers (1.0.0-alpha.9 < 1.0.0-alpha.10)' do
          let(:version) { '1.0.0-alpha.9' }
          let(:other_version) { '1.0.0-alpha.10' }
          it 'should sort those identifiers numerically (i.e. 9 < 10)' do
            expect(semver_version <=> other_semver_version).to eq(-1)
            expect(other_semver_version <=> semver_version).to eq(1)
          end
        end

        context 'when the pre-release parts have non-numerical identifiers (1.0.0-alpha < 1.0.0-beta)' do
          let(:version) { '1.0.0-alpha' }
          let(:other_version) { '1.0.0-beta' }
          it 'short sort those identifiers lexicographically (i.e. "alpha" < "beta")' do
            expect(semver_version <=> other_semver_version).to eq(-1)
            expect(other_semver_version <=> semver_version).to eq(1)
          end
        end

        context 'when pre-release identifiers differ in type of identifiers (1.0.0-alpha.999 < 1.0.0-alpha.a)' do
          let(:version) { '1.0.0-alpha.999' }
          let(:other_version) { '1.0.0-alpha.a' }
          it 'should sort the numeric identifier before the non-numeric identifier (i.e. 999 < "a")' do
            expect(semver_version <=> other_semver_version).to eq(-1)
            expect(other_semver_version <=> semver_version).to eq(1)
          end
        end
      end
    end
  end

  describe '#to_s' do
    subject { described_class.new(version).to_s }
    let(:version) { '1.0.0-pre.1+AMD64' }

    it 'should return the version string' do
      expect(subject).to eq(version)
    end
  end

  describe '#==' do
    subject { described_class.new(version) == described_class.new(other_version) }
    context "with version '1.2.3-alpha.1+AMD64'" do
      let(:version) { '1.2.3-alpha.1+AMD64' }
      context "with other version '1.2.3-alpha.1+AMD64'" do
        let(:other_version) { '1.2.3-alpha.1+AMD64' }
        it { is_expected.to eq(true) }
      end
      context "with other version '1.2.3'" do
        let(:other_version) { '1.2.3' }
        it { is_expected.to eq(false) }
      end
      context "with other version '1.2.3-alpha.1'" do
        let(:other_version) { '1.2.3-alpha.1' }
        it { is_expected.to eq(false) }
      end
      context "with other version '1.2.3+AMD64'" do
        let(:other_version) { '1.2.3+AMD64' }
        it { is_expected.to eq(false) }
      end
    end
  end
end
