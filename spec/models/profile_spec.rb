require 'rails_helper'

RSpec.describe Profile, type: :model do
  describe "バリデーションチェック" do
    subject { FactoryBot.build(:user) }
    subject { FactoryBot.build(:profile) }

    context "nickname" do
      it { is_expected.to validate_presence_of(:nickname) }
      it { is_expected.to validate_length_of(:nickname).is_at_most(30) }
      it { is_expected.to validate_uniqueness_of(:nickname).ignoring_case_sensitivity }
    end

    context "sex" do
      it { is_expected.to define_enum_for(:sex).with_values(hidden: 0, male: 1, female: 2) }
      it "デフォルトはhidden" do
        profile = FactoryBot.build(:profile)
        expect(profile.sex).to eq "hidden"
      end
    end

    context "introduction" do
      it { is_expected.to validate_length_of(:introduction).is_at_most(255) }
    end

    context "avatar" do
      it "pngもしくはjpegファイルは有効" do
        profile = FactoryBot.build(:profile)
        profile.avatar.attach(
          io: File.open(
            Rails.root.join("spec/fixtures/files/image/test_png.png")
          ),
          filename: "test_png.png",
          content_type: "image/png"
        )
        expect(profile).to be_valid
      end

      it "pngまたはjpegファイル以外は無効" do
        profile = FactoryBot.build(:profile)
        profile.avatar.attach(
          io: File.open(
            Rails.root.join("spec/fixtures/files/image/test_svg.svg")
          ),
          filename: "test_svg.svg",
          content_type: "image/svg"
        )
        expect(profile).to be_invalid
      end

      it "ファイルサイズが534_288_000バイト以上は無効" do
        profile = FactoryBot.build(:profile)
        file = Tempfile.new([ "large", ".png" ])
        file.write("a" * 524_288_001)
        file.rewind
        profile.avatar.attach(
          Rack::Test::UploadedFile.new(file.path, "image/png")
        )
        expect(profile).to be_invalid
      end
    end

    describe "アイソレーション" do
      it { is_expected.to have_one_attached(:avatar) }
      it { is_expected.to belong_to(:user) }
    end
  end
end
