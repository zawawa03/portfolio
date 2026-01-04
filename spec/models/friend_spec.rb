require 'rails_helper'

RSpec.describe Friend, type: :model do
  describe "バリデーションチェック" do
    subject { FactoryBot.build(:friend) }

    context "leader_id" do
      it { is_expected.to validate_uniqueness_of(:leader_id).scoped_to(:follower_id) }
    end

    context "catogory" do
      it { is_expected.to validate_presence_of(:category) }
      it { is_expected.to define_enum_for(:category).with_values(apply: 0, friendship: 1, blocked: 2) }
    end
  end

  describe "アイソレーション" do
    it { is_expected.to belong_to(:leader).class_name("User") }
    it { is_expected.to belong_to(:follower).class_name("User") }
  end
end
