require 'rails_helper'

RSpec.describe "AdminGames", type: :system do
  include AdminLoginMacros

  describe "管理画面" do
    let!(:user) { FactoryBot.create(:user, email: "user01@example.com", role: "admin") }
    let!(:profile) { FactoryBot.create(:profile, user: user) }
    let!(:game) { FactoryBot.create(:game, :with_picture) }

    before { login_admin(user) }

    context "ゲームタイトル機能" do
      it "ゲームタイトル一覧にアクセスできる" do
        find(".navbar-toggler").click
        click_on "ゲームタイトル"
        expect(page).to have_content("ゲームタイトル一覧")
      end

      it "ゲームタイトルを追加できる" do
        find(".navbar-toggler").click
        click_on "ゲームタイトル"
        fill_in "ゲームタイトル", with: "マリオ"
        attach_file("game[picture]", Rails.root.join("spec/fixtures/files/image/test_png.png"))
        click_on "登録"
        expect(page).to have_content("ゲームタイトルを追加しました")
        expect(page).to have_content("マリオ")
      end

      it "タイトルを入力しないと無効" do
        find(".navbar-toggler").click
        click_on "ゲームタイトル"
        attach_file("game[picture]", Rails.root.join("spec/fixtures/files/image/test_png.png"))
        click_on "登録"
        expect(page).to have_content("ゲームタイトルを入力してください")
        expect(page).to have_content("ゲームタイトルを追加できませんでした")
      end

      it "サムネイルを追加しないとエラー" do
        find(".navbar-toggler").click
        click_on "ゲームタイトル"
        fill_in "ゲームタイトル", with: "マリオ"
        click_on "登録"
        expect(page).to have_content("サムネイルを入力してください")
        expect(page).to have_content("ゲームタイトルを追加できませんでした")
      end

      it "ゲームタイトルを削除できる" do
        find(".navbar-toggler").click
        click_on "ゲームタイトル"
        click_link "削除", href: "/admin/games/#{game.id}"
        expect(page).not_to have_content("テストゲーム")
      end
    end
  end
end
