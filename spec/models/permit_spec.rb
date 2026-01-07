require 'rails_helper'

RSpec.describe Permit, type: :model do
  describe "バリデーションチェック" do
    let!(:user) { FactoryBot.create(:user, email: "user01@example.com") }
    let!(:profile) { FactoryBot.create(:profile, user: user) }
    let!(:game) { FactoryBot.create(:game, :with_picture) }
    let!(:room) { FactoryBot.create(:room, creator: user, game: game) }
    subject { FactoryBot.build(:permit, user: user, room: room) }

    context "user_id" do
      it { is_expected.to validate_uniqueness_of(:user_id).scoped_to(:room_id) }
    end
  end

  describe "アイソレーション" do
    subject { FactoryBot.build(:permit) }
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:room) }
  end
end
