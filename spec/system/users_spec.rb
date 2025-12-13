require 'rails_helper'

RSpec.describe "Users", type: :system do
  include LoginMacros

  describe "user機能" do
    let!(:user) { FactoryBot.create(:user) }
    context "login" do
      it "正しいメール、パスワードでログインできる" do
        visit new_user_session_path
        fill_in "メールアドレス", with: user.email
        fill_in "パスワード", with: user.password
        find("#session_btn").click
        expect(page).to have_content("ログインしました")
      end

      it "ログイン後に指定のページへ遷移する" do
        login(user)
        expect(page).to have_content("ログインしました")
        expect(current_path).to eq(root_path)
      end

      it "間違ったメールではログインできない" do
        visit new_user_session_path
        fill_in "メールアドレス", with: "abcd@example.com"
        fill_in "パスワード", with: user.password
        find("#session_btn").click
        expect(page).to have_content("ログインに失敗しました。パスワードまたはメールアドレスが違います。")
      end

      it "間違ったパスワードではログインできない" do
        visit new_user_session_path
        fill_in "メールアドレス", with: user.email
        fill_in "パスワード", with: "password00"
        find("#session_btn").click
        expect(page).to have_content("ログインに失敗しました。パスワードまたはメールアドレスが違います。")
      end

      it "アカウントが存在しない場合エラーが出る" do
        user = FactoryBot.build(:user)
        login(user)
        expect(page).to have_content("ログインに失敗しました。パスワードまたはメールアドレスが違います。")
      end
    end
  end
end
