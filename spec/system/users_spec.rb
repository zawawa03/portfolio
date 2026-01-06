require 'rails_helper'

RSpec.describe "Users", type: :system do
  include LoginMacros
  include SendResetPasswordMail
  include OmniauthMacros

  describe "user機能" do
    let!(:user) { FactoryBot.create(:user, email: "user01@example.com") }
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

      it "Google認証でログインできる" do
        mock_google_oauth2_auth
        visit new_user_session_path
        click_on "Googleでログイン"
        expect(page).to have_content("googleアカウントによる認証に成功しました。")
      end
    end

    context "logout" do
      let!(:user) { FactoryBot.create(:user) }
      before { login(user) }

      it "ログアウトできる" do
        click_on "ログアウト"
        expect(current_path).to eq(root_path)
        expect(page).to have_content("ログアウトしました")
      end
    end

    context "registration" do
      let!(:user) { FactoryBot.build(:user) }

      it "ユーザー登録できる" do
        visit new_user_registration_path
        fill_in "姓", with: user.last_name
        fill_in "名", with: user.first_name
        fill_in "メールアドレス", with: user.email
        fill_in "パスワード (6文字以上で入力してください)", with: user.password
        fill_in "パスワード（確認用）", with: user.password_confirmation
        click_on "登録"
        expect(page).to have_content("ユーザー登録が完了しました。")
      end
      it "ユーザー登録後プロフィール登録画面へ遷移" do
        visit new_user_registration_path
        fill_in "姓", with: user.last_name
        fill_in "名", with: user.first_name
        fill_in "メールアドレス", with: user.email
        fill_in "パスワード (6文字以上で入力してください)", with: user.password
        fill_in "パスワード（確認用）", with: user.password_confirmation
        click_on "登録"
        expect(page).to have_content("ユーザー登録が完了しました。")
        expect(current_path).to eq(new_profile_path)
      end
      it "メールが未入力だと登録に失敗" do
        visit new_user_registration_path
        fill_in "姓", with: user.last_name
        fill_in "名", with: user.first_name
        fill_in "メールアドレス", with: ""
        fill_in "パスワード (6文字以上で入力してください)", with: user.password
        fill_in "パスワード（確認用）", with: user.password_confirmation
        click_on "登録"
        expect(current_path).to eq(new_user_registration_path)
        expect(page).to have_content("メールアドレスを入力してください")
      end
      it "パスワードが未入力だと登録に失敗" do
        visit new_user_registration_path
        fill_in "姓", with: user.last_name
        fill_in "名", with: user.first_name
        fill_in "メールアドレス", with: user.email
        fill_in "パスワード (6文字以上で入力してください)", with: ""
        fill_in "パスワード（確認用）", with: user.password_confirmation
        click_on "登録"
        expect(current_path).to eq(new_user_registration_path)
        expect(page).to have_content("パスワードを入力してください")
      end
      it "パスワードが６文字以下だと登録に失敗" do
        visit new_user_registration_path
        fill_in "姓", with: user.last_name
        fill_in "名", with: user.first_name
        fill_in "メールアドレス", with: user.email
        fill_in "パスワード (6文字以上で入力してください)", with: "abcde"
        fill_in "パスワード（確認用）", with: "abcde"
        click_on "登録"
        expect(current_path).to eq(new_user_registration_path)
        expect(page).to have_content("パスワードは6文字以上で入力してください")
      end
      it "登録済みのメールを入力すると失敗" do
        user2 = FactoryBot.create(:user, email: "user1@example.com")
        visit new_user_registration_path
        fill_in "姓", with: user.last_name
        fill_in "名", with: user.first_name
        fill_in "メールアドレス", with: "user1@example.com"
        fill_in "パスワード (6文字以上で入力してください)", with: user.password
        fill_in "パスワード（確認用）", with: user.password
        click_on "登録"
        expect(current_path).to eq(new_user_registration_path)
        expect(page).to have_content("メールアドレスはすでに存在します")
      end
    end

    context "パスワード再設定" do
      let!(:user) { FactoryBot.create(:user) }

      it "有効なメールアドレスを入力送信するとリセットメールが送信される" do
        send_reset_mail(user)
        expect(page).to have_content("パスワード再設定のメールを送信しました。")
      end

      it "無効なメールアドレスを入力送信するとエラー" do
        visit new_user_password_path
        fill_in "メールアドレス", with: "abcde@example.com"
        click_on "再設定メール送信"
        expect(page).to have_content("パスワード再設定のメールが送信できませんでした。")
      end

      it "再設定画面へ遷移できる" do
        raw, enc = Devise.token_generator.generate(User, :reset_password_token)
        user.update!(
        reset_password_token: enc,
        reset_password_sent_at: Time.current
        )
        visit edit_user_password_path(reset_password_token: raw)
        expect(page).to have_content("パスワードリセット")
      end

      it "パスワードを再設定できる" do
        raw, enc = Devise.token_generator.generate(User, :reset_password_token)
        user.update!(
        reset_password_token: enc,
        reset_password_sent_at: Time.current
        )
        visit edit_user_password_path(reset_password_token: raw)
        fill_in "パスワード (6文字以上で入力してください)", with: "new_password"
        fill_in "パスワード（確認用）", with: "new_password"
        click_on "パスワード変更"
        expect(page).to have_content("パスワードが正しく変更されました。")
      end
    end

    context "ユーザー編集" do
      let!(:user) { FactoryBot.create(:user) }

      it "ユーザー情報ページへ遷移できる" do
        login(user)
        visit setting_path
        expect(page).to have_content("ユーザー情報")
      end

      it "ユーザー情報更新ページへ遷移できる" do
        login(user)
        visit setting_path
        click_on "編集"
        expect(page).to have_content("ユーザー情報更新")
      end

      it "ユーザー情報を編集できる" do
        login(user)
        visit edit_user_registration_path
        fill_in "姓", with: "中村"
        fill_in "名", with: "悠一"
        fill_in "メールアドレス", with: "user_edit@example.com"
        click_on "更新"
        expect(page).to have_content("ユーザー情報を変更しました")
        expect(current_path).to eq(setting_path)
      end

      it "メルアドレスが未入力だと変更できない" do
        login(user)
        visit edit_user_registration_path
        fill_in "姓", with: "中村"
        fill_in "名", with: "悠一"
        fill_in "メールアドレス", with: ""
        click_on "更新"
        expect(page).to have_content("メールアドレスを入力してください")
      end
    end
  end
end
