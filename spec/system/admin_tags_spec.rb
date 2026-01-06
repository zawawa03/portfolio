require 'rails_helper'

RSpec.describe "AdminTags", type: :system do
  include AdminLoginMacros

  describe "管理画面" do
    let!(:user) { FactoryBot.create(:user, email: "user01@example.com", role: "admin") }
    let!(:profile) { FactoryBot.create(:profile, user: user) }
    let!(:tag) { FactoryBot.create(:tag) }

    before { login_admin(user) }

    context "タグ系機能" do
      it "タグ一覧にアクセスできる" do
        find(".navbar-toggler").click
        click_on "タグ一覧"
        expect(page).to have_content("タグ一覧")
      end

      it "タグを追加できる" do
        find(".navbar-toggler").click
        click_on "タグ一覧"
        select "ゲームモード", from: "tag[category]"
        fill_in "タグ名", with: "ランク戦"
        click_on "登録"
        expect(page).to have_content("タグを作成しました")
      end

      it "カテゴリ選択をしないと無効" do
        find(".navbar-toggler").click
        click_on "タグ一覧"
        fill_in "タグ名", with: "ランク戦"
        click_on "登録"
        expect(page).to have_content("タグを作成できませんでした")
      end

      it "タグ名を入力しないと無効" do
        find(".navbar-toggler").click
        click_on "タグ一覧"
         select "ゲームモード", from: "tag[category]"
        click_on "登録"
        expect(page).to have_content("タグを作成できませんでした")
      end

      it "タグを削除できる" do
        find(".navbar-toggler").click
        click_on "タグ一覧"
        click_link "削除", href: "/admin/tags/#{tag.id}"
        accept_confirm do
          expect(page.driver.browser.switch_to.alert.text).to eq("削除しますか？")
        end
        expect(page).to have_content("タグを削除しました")
      end
    end
  end
end
