require 'rails_helper'

RSpec.describe "Notifications", type: :system do
  include LoginMacros

  describe "通知機能" do
    let!(:user) { FactoryBot.create(:user) }
    let!(:user2) { FactoryBot.create(:user, first_name: "ゆうと", last_name: "吉田") }
    let!(:profile) { FactoryBot.create(:profile, user: user) }
    let!(:profile2) { FactoryBot.create(:profile, nickname: "ゆうと", user: user2) }
    let!(:notification) { FactoryBot.create(:notification, sender: user, receiver: user2) }
    let!(:notification2) { FactoryBot.create(:notification, :friend_app, sender: user, receiver: user2) }
    let!(:notification3) { FactoryBot.create(:notification, :friend_noti, sender: user, receiver: user2) }
    let!(:friend) { FactoryBot.create(:friend, leader: user2, follower: user) }

    context "未ログイン時" do
      it "ヘッダーにリンクが表示されない" do
        visit root_path
        expect(page).not_to have_content("#notification_field")
      end
    end

    context "ログイン時" do

      before { login(user2) }

      it "ヘッダーのリンクから一覧画面へアクセスできる" do
        visit root_path
        find(".bi-bell").click
        expect(page).to have_content("通知一覧")
      end

      it "募集の承認通知が確認できる" do
        visit notifications_path
        expect(page).to have_content("申請した募集に参加できます")
      end

      it "フレンド申請の通知が確認できる" do
        visit notifications_path
        expect(page).to have_content("フレンド申請が届きました")
      end

      it "フレンド承認の通知が確認できる" do
        visit notifications_path
        expect(page).to have_content("フレンド申請が承認されました")
      end
    end
  end
end
