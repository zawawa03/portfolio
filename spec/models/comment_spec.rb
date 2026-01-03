require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe "バリデーションチェック" do
    subject { FactoryBot.build(:comment) }

    context "user" do
      it "user_idがnilでも通る" do
        comment = FactoryBot.build(:comment, user: nil)
        expect(comment).to be_valid
      end
    end

    context "parent" do
      it "parent_idがnilでも通る" do
        comment = FactoryBot.build(:comment, parent: nil)
        expect(comment).to be_valid
      end
    end

    context "body" do
      it { is_expected.to validate_presence_of(:body) }
      it { is_expected.to validate_length_of(:body).is_at_most(255) }
    end

    context "media" do
      it "pngかjpegのみ有効" do
        comment = FactoryBot.build(:comment)
        comment.media.attach(
          io: File.open(
            Rails.root.join("spec/fixtures/files/image/test_png.png")
          ),
          filename: "test_png.png",
          content_type: "image/png"
        )
        expect(comment).to be_valid
      end

      it "pngかjpeg以外は無効" do
        comment = FactoryBot.build(:comment)
        comment.media.attach(
          io: File.open(
            Rails.root.join("spec/fixtures/files/image/test_svg.svg")
          ),
          filename: "test_svg.svg",
          content_type: "image/svg"
        )
        expect(comment).to be_invalid
      end

      it "サイズが524_288_000以上だと無効" do
        comment = FactoryBot.build(:comment)
        file = Tempfile.new([ "large", ".png" ])
        file.write("a" * 524_288_001)
        file.rewind
        comment.media.attach(
          Rack::Test::UploadedFile.new(file.path, "image/png")
        )
        expect(comment).to be_invalid
      end
    end
  end

  describe "アイソレーション" do
    it { is_expected.to have_many_attached(:media) }
    it { is_expected.to belong_to(:board) }
    it { is_expected.to belong_to(:user).optional }
    it { is_expected.to belong_to(:parent).class_name("Comment").optional }
    it { is_expected.to have_many(:childrens).class_name("Comment").with_foreign_key("parent_id").dependent(:destroy) }
  end
end
