require 'rails_helper'

RSpec.describe Board, type: :model do
  describe "バリデーションチェック" do
    subject { FactoryBot.build(:board) }

    context "タイトル" do
      it { is_expected.to validate_presence_of(:title) }
      it { is_expected.to validate_length_of(:title).is_at_most(255) }
    end
  end

  describe "アイソレーション" do
    subject { FactoryBot.build(:board) }
    it { is_expected.to belong_to(:creator).class_name("User") }
    it { is_expected.to belong_to(:game) }
    it { is_expected.to have_many(:board_tags).dependent(:destroy) }
    it { is_expected.to have_many(:tags) }
    it { is_expected.to have_many(:comments).dependent(:destroy) }
  end
end
