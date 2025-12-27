require 'rails_helper'

RSpec.describe Room, type: :model do
  describe "バリデーションチェック" do
    subject { FactoryBot.build(:room) }

    context "title" do
      it { is_expected.to validate_presence_of(:title) }
      it { is_expected.to validate_length_of(:title).is_at_most(50) }
    end

    context "body" do
      it { is_expected.to validate_length_of(:body).is_at_most(255) }
    end

    context "people" do
      it { is_expected.to validate_presence_of(:people) }
      it do
        is_expected.to validate_numericality_of(:people).
          only_integer.
          is_greater_than_or_equal_to(1).
          is_less_than_or_equal_to(50)
      end
    end

    context "category" do
      it { is_expected.to define_enum_for(:category).with_values(game: 0, friend: 1) }
    end
  end

  describe "アイソレーション" do
    it { is_expected.to belong_to(:creator).class_name("User") }
    it { is_expected.to belong_to(:game) }
    it { is_expected.to have_many(:room_tags).dependent(:destroy) }
    it { is_expected.to have_many(:tags) }
    it { is_expected.to have_many(:permits).dependent(:destroy) }
    it { is_expected.to have_many(:user_rooms).dependent(:destroy) }
    it { is_expected.to have_many(:users) }
    it do
      should have_many(:permit_users).
      through(:permits).
      source(:user)
    end
    it { is_expected.to have_many(:messages).dependent(:destroy) }
  end
end
