require 'rails_helper'

RSpec.describe Permit, type: :model do
  describe "バリデーションチェック" do
    subject { FactoryBot.build(:user) }
    subject { FactoryBot.build(:room) }
    subject { FactoryBot.build(:permit) }

    context "user_id" do
      it { is_expected.to validate_uniqueness_of(:user_id).scoped_to(:room_id) }
    end
  end
end
