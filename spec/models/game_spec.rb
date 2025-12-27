require 'rails_helper'

RSpec.describe Game, type: :model do
  describe "バリデーションチェック" do
    subject { FactoryBot.build(:game) }

    context "name" do
      it { is_expected.to validate_presence_of(:name) }
    end

    context "picture" do
      it { is_expected.to validate_presence_of(:picture) }

      it "pngもしくはjpegファイルは有効" do
        game = FactoryBot.build(:game, :with_picture)
        expect(game).to be_valid
      end

      it "pngまたはjpegファイル以外は無効" do
        game = FactoryBot.build(:game)
        game.picture.attach(
          io: File.open(
            Rails.root.join("spec/fixtures/files/image/test_svg.svg")
          ),
          filename: "test_svg.svg",
          content_type: "image/svg"
        )
        expect(game).to be_invalid
      end

      it "ファイルサイズが534_288_000バイト以上は無効" do
        game = FactoryBot.build(:game)
        file = Tempfile.new([ "large", ".png" ])
        file.write("a" * 524_288_001)
        file.rewind
        game.picture.attach(
          Rack::Test::UploadedFile.new(file.path, "image/png")
        )
        expect(game).to be_invalid
      end
    end
  end

  describe "アイソレーション" do
    subject { FactoryBot.build(:game) }
    it { is_expected.to have_many(:rooms).dependent(:destroy) }
    it { is_expected.to have_many(:boards).dependent(:destroy) }
    it { is_expected.to have_one_attached(:picture) }
  end
end
