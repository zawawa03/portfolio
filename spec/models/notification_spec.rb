require 'rails_helper'

RSpec.describe Notification, type: :model do
  describe "バリデーションチェック" do
    subject { FactoryBot.build(:notification) }

    context "category" do
      it { is_expected.to validate_presence_of(:category) }
      it { is_expected.to define_enum_for(:category).with_values(room: 0, friend_apply: 1, friend_permit: 2) }
    end
  end
end
