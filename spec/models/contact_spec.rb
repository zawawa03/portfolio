require 'rails_helper'

RSpec.describe Contact, type: :model do
  describe "バリデーションチェック" do
    subject { FactoryBot.build(:contact) }

    context "email" do
      it { is_expected.to validate_presence_of(:email) }
    end

    context "name" do
      it { is_expected.to validate_presence_of(:name) }
    end

    context "body" do
      it { is_expected.to validate_presence_of(:body) }
      it { is_expected.to validate_length_of(:body).is_at_most(1000) }
    end
  end
end
