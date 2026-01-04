require 'rails_helper'

RSpec.describe Permit, type: :model do
  describe "バリデーションチェック" do
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
