require 'rails_helper'

RSpec.describe "Admins", type: :system do
  include AdminLoginMacros

  describe "管理画面" do
    let!(:user) { FactoryBot.create(:user, email: "user_01@example.com", role: "admin") }
    let!(:user2) { FactoryBot.create(:user, :another, email: "user_02@example.com") }
    let!(:profile) { FactoryBot.create(:profile, user: user) }
    let!(:profile2) { FactoryBot.create(:profile, :another, user: user2) }

    context "ユーザー認証", :skip_before do
      it "ログイン画面へアクセスできる" do
        visit admin_login_path
        expect(page).to have_content("管理者ログイン画面")
      end

      it "ロールがadminならアクセスできる" do
        visit admin_login_path
        fill_in "メールアドレス", with: user.email
        fill_in "パスワード", with: "password"
        click_on "ログイン"
        expect(page).to have_content("管理画面トップページです")
      end

      it "ロールがgeneralならアクセスできない" do
        visit admin_login_path
        fill_in "メールアドレス", with: user2.email
        fill_in "パスワード", with: "password"
        click_on "ログイン"
        expect(page).not_to have_content("管理画面トップページです")
      end

      it "ログアウトできる" do
        visit admin_login_path
        fill_in "メールアドレス", with: user.email
        fill_in "パスワード", with: "password"
        click_on "ログイン"
        find(".navbar-toggler").click
        click_on "ログアウト"
        expect(page).to have_content("ログアウトしました")
      end
    end

    context "ユーザー機能" do
      it "ユーザー一覧にアクセスできる" do
        login_admin(user)
        find(".navbar-toggler").click
        click_on "ユーザー一覧"
        expect(page).to have_content("ユーザー一覧")
      end

      it "ユーザー詳細にアクセスできる" do
        login_admin(user)
        find(".navbar-toggler").click
        click_on "ユーザー一覧"
        find_link(href: "/admin/users/#{user.id}").click
        expect(page).to have_content("ユーザー情報")
        expect(page).to have_content("ユーザープロフィール")
      end

      it "ユーザー編集画面へアクセスできる" do
        login_admin(user)
        find(".navbar-toggler").click
        click_on "ユーザー一覧"
        find_link(href: "/admin/users/#{user2.id}").click
        click_link(href: "/admin/user_edit/#{user2.id}")
        expect(page).to have_content("ユーザー編集")
      end

      it "ユーザーを編集できる" do
        login_admin(user)
        find(".navbar-toggler").click
        click_on "ユーザー一覧"
        find_link(href: "/admin/users/#{user2.id}").click
        click_link(href: "/admin/user_edit/#{user2.id}")
        select "管理者", from: "権限"
        click_on "更新"
        expect(page).to have_content("ユーザー情報を更新しました")
      end

      it "ユーザープロフィール編集画面へアクセスできる" do
        login_admin(user)
        find(".navbar-toggler").click
        click_on "ユーザー一覧"
        find_link(href: "/admin/users/#{user2.id}").click
        within("#admin-profile") do
          click_on "編集"
        end
        expect(page).to have_content("プロフィール編集")
      end

      it "ユーザープロフィールを編集できる" do
        login_admin(user)
        find(".navbar-toggler").click
        click_on "ユーザー一覧"
        find_link(href: "/admin/users/#{user2.id}").click
        within("#admin-profile") do
          click_on "編集"
        end
        fill_in "ニックネーム", with: "ケント"
        click_on "更新"
        expect(page).to have_content("プロフィールを更新しました")
      end

      it "ユーザーを削除できる" do
        login_admin(user)
        find(".navbar-toggler").click
        click_on "ユーザー一覧"
        find_link(href: "/admin/users/#{user2.id}").click
        click_on "削除"
        accept_confirm do
          expect(page.driver.browser.switch_to.alert.text).to eq("ユーザーを削除しますか？")
        end
        expect(page).to have_content("ユーザー情報を削除しました")
      end

      it "名前で検索できる" do
        login_admin(user)
        find(".navbar-toggler").click
        click_on "ユーザー一覧"
        fill_in "q[last_name]", with: "田中"
        click_on "検索"
        expect(page).to have_content("田中 らんて")
      end

      it "ロールで検索できる" do
        login_admin(user)
        find(".navbar-toggler").click
        click_on "ユーザー一覧"
        select "管理者", from: "q[role_name]"
        click_on "検索"
        expect(page).to have_content("田中 らんて")
      end
    end
  end
end
