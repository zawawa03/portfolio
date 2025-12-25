require 'rails_helper'

RSpec.describe "Rooms", type: :system do
  include LoginMacros
  describe "room機能" do
    context "一覧機能" do
      let!(:user) { FactoryBot.create(:user) }
      let!(:profile) { FactoryBot.create(:profile, user: user) }
      let!(:game) { FactoryBot.create(:game, :with_picture) }
      let!(:room) { FactoryBot.create(:room, creator: user, game: game) }

      
      it "募集一覧リンクから一覧へアクセスできる" do
        visit rooms_path
        expect(page).to have_content("募集一覧")
      end

      it "一覧に募集が表示されている" do
        visit rooms_path
        expect(page).to have_content("テストゲーム")
      end
    end
  end
end
