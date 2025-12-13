require 'rails_helper'

RSpec.describe User, type: :model do
  describe "バリデーションチェック" do
    subject { FactoryBot.build(:user) }

    context "first_name" do
      it "空文字は有効、nilは無効" do
        user = FactoryBot.build(:user, first_name: nil)
        expect(user).to be_invalid
        expect(user.errors[:first_name]).to include("can't be nil")
      end
      it { is_expected.to validate_length_of(:first_name).is_at_most(255) }
    end

    context "last_name" do
      it "空文字は有効、nilは無効" do
        user = FactoryBot.build(:user, last_name: nil)
        expect(user).to be_invalid
        expect(user.errors[:last_name]).to include("can't be nil")
      end
      it { is_expected.to validate_length_of(:last_name).is_at_most(255) }
    end

    context "email" do
      it { is_expected.to validate_presence_of(:email) }
      it { is_expected.to validate_uniqueness_of(:email).ignoring_case_sensitivity }
    end

    context "password" do
      it { is_expected.to validate_presence_of(:password) }
      it { is_expected.to validate_presence_of(:password_confirmation) }
      it { is_expected.to validate_length_of(:password).is_at_least(6) }
    end

    context "role" do
      it { is_expected.to define_enum_for(:role).with_values(general: 0, admin: 1) }
      it "デフォルトはgeneral" do
        user = FactoryBot.build(:user)
        expect(user.role).to eq "general"
      end
    end

    context "uid" do
      it "providerがあるときはuidが必要" do
        user = FactoryBot.build(:user, uid: nil, provider: "google_oauth2")
        expect(user).to be_invalid
      end
      it "providerがないときはuidが無くてもよい" do
        user = FactoryBot.build(:user, provider: nil, uid: nil)
        expect(user).to be_valid
      end
      it { is_expected.to validate_uniqueness_of(:uid).scoped_to(:provider).ignoring_case_sensitivity }
    end
  end  
   
  describe "アイソレーションチェック" do
    it { is_expected.to have_one(:profile).dependent(:destroy) }
    it { is_expected.to have_many(:rooms).dependent(:destroy) }
    it { is_expected.to have_many(:permits).dependent(:destroy) }
    it { is_expected.to have_many(:user_rooms).dependent(:destroy) }
    it { is_expected.to have_many(:send_notifications).dependent(:destroy) }
    it { is_expected.to have_many(:receive_notifications).dependent(:destroy) }
    it { is_expected.to have_many(:leader_friends).dependent(:destroy) }
    it { is_expected.to have_many(:follower_friends).dependent(:destroy) }
    it { is_expected.to have_many(:messages) }
    it { is_expected.to have_many(:boards).dependent(:destroy) }
    it { is_expected.to have_many(:comments) }
  end    
end
