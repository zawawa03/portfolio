require 'rails_helper'

RSpec.describe "Profiles", type: :system do
  include LoginMacros

  describe "profile機能" do
    let!(:user) { FactoryBot.create(:user) }
    let(:profile) { FactoryBot.build(:profile) }
    before { login(user) }

    context "profile/new" do
      it "プロフィールを作成できる" do
        visit new_profile_path
        fill_in "ニックネーム", with: profile.nickname
        select "非表示", from: "性別"
        fill_in "自己紹介", with: "よろしく"
        attach_file('profile[avatar]',  Rails.root.join('spec/fixtures/files/image/test_png.png'))
        click_on "登録"
        expect(page).to have_content("プロフィールを作成しました")
      end

      it "ニックネームを入力しないとエラー" do
        visit new_profile_path
        fill_in "ニックネーム", with: nil
        select "非表示", from: "性別"
        click_on "登録"
        expect(page).to have_content("プロフィールを作成できませんでした")
      end

      it "自己紹介が255文字以上だとエラー" do
        visit new_profile_path
        fill_in "ニックネーム", with: profile.nickname
        select "非表示", from: "性別"
        fill_in "自己紹介", with: "a"*256
        click_on "登録"
        expect(page).to have_content("プロフィールを作成できませんでした")
      end

      it "プロフィール登録後はトップページへ" do
        visit new_profile_path
        fill_in "ニックネーム", with: profile.nickname
        select "非表示", from: "性別"
        fill_in "自己紹介", with: profile.introduction
        click_on "登録"
        expect(page).to have_current_path(root_path)
      end

      it "プロフィール画面へアクセスできる" do
        profile = FactoryBot.create(:profile, user: user)
        visit user_profile_path(user)
        expect(page).to have_content("プロフィール")
        expect(page).to have_content(profile.nickname)
      end

      it "プロフィール編集画面へアクセスできる" do
        profile = FactoryBot.create(:profile, user: user)
        visit user_profile_path(user)
        click_on "編集"
        expect(page).to have_current_path(edit_profile_path)
        expect(page).to have_content("プロフィール編集")
      end

      it "プロフィールを編集できる" do
        profile = FactoryBot.create(:profile, user: user)
        visit user_profile_path(user)
        click_on "編集"
        fill_in "ニックネーム", with: "やまだ"
        select "男性", from: "性別"
        fill_in "profile[introduction]", with: "こんにちわ"
        click_on "更新"
        expect(page).to have_content("プロフィールを更新しました")
      end

      it "プロフィール編集後はプロフィール画面へ" do
        profile = FactoryBot.create(:profile, user: user)
        visit user_profile_path(user)
        click_on "編集"
        fill_in "ニックネーム", with: "やまだ"
        select "男性", from: "性別"
        fill_in "profile[introduction]", with: "こんにちわ"
        click_on "更新"
        expect(page).to have_current_path(user_profile_path(user))
      end
    end
  end
end
