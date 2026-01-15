require 'rails_helper'

RSpec.describe "Descriptions", type: :system do
  describe "アプリの使いかたページ" do
    it "アプリの使いかたページにアクセスできる" do
      visit root_path
      click_on "アプリの使い方"
      expect(page).to have_content("アプリの使い方")
    end

    it "それぞれの使い方が表示されている" do
      visit description_path
      expect(page).to have_content("パーティー募集の参加方法")
      expect(page).to have_content("パーティー募集方法")
      expect(page).to have_content("掲示板の使いかた")
    end
  end
end
