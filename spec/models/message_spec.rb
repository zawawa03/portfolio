require 'rails_helper'

RSpec.describe Message, type: :model do
  describe "バリデーションチェック" do
    subject { FactoryBot.build(:message) }

    context "body" do
      it { is_expected.to validate_presence_of(:body) }
      it { is_expected.to validate_length_of(:body).is_at_most(255) }
    end
  end
  describe "アイソレーション" do
    subject { FactoryBot.build(:message) }
    it { is_expected.to belong_to(:room) }
    it { is_expected.to belong_to(:user) }
  end
end
