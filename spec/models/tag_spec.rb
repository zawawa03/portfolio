require 'rails_helper'

RSpec.describe Tag, type: :model do
  describe "バリデーションチェック" do
    subject { FactoryBot.build(:tag) }

    context "name" do
      it { is_expected.to validate_presence_of(:name) }
      it { is_expected.to validate_length_of(:name).is_at_most(20) }
      it { is_expected.to validate_uniqueness_of(:name).scoped_to(:category).ignoring_case_sensitivity }
    end

    context "category" do
      it { is_expected.to validate_presence_of(:category) }
      it { is_expected.to define_enum_for(:category).with_values(mode: 0, style: 1, ability: 2, board: 3) }
    end
  end

  describe "アイソレーション" do
    subject { FactoryBot.build(:tag) }

    it { is_expected.to have_many(:room_tags) }
    it { is_expected.to have_many(:rooms) }
  end
end
