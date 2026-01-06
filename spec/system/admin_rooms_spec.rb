require 'rails_helper'

RSpec.describe "AdminRooms", type: :system do
  include AdminLoginMacros

  describe "管理画面" do
    let!(:user) { FactoryBot.create(:user, email: "user_01@example.com", role: "admin") }
    let!(:user2) { FactoryBot.create(:user, :another, email: "user_02@example.com") }
    let!(:profile) { FactoryBot.create(:profile, user: user) }
    let!(:profile2) { FactoryBot.create(:profile, :another, user: user2) }
    let!(:game) { FactoryBot.create(:game, :with_picture) }
    let!(:room) { FactoryBot.create(:room, creator: user, game: game) }
    let!(:user_room) { FactoryBot.create(:user_room, user: user, room: room) }
    let!(:user_room2) { FactoryBot.create(:user_room, user: user2, room: room) }
    let!(:message) { FactoryBot.create(:message, room: room, user: user) }

    before { login_admin(user) }

    context "募集機能" do
      it "募集一覧にアクセスできる" do
        find(".navbar-toggler").click
        click_on "募集一覧"
        expect(page).to have_content("ルーム一覧")
      end

      it "募集詳細にアクセスできる" do
        find(".navbar-toggler").click
        click_on "募集一覧"
        click_link "詳細", href: "/admin/rooms/#{room.id}"
        expect(page).to have_content("募集詳細")
      end

      it "参加者を確認できる" do
        find(".navbar-toggler").click
        click_on "募集一覧"
        click_link "詳細", href: "/admin/rooms/#{room.id}"
        expect(page).to have_content("田中 らんて")
        expect(page).to have_content("吉田 ゆうと")
      end

      it "メッセージを確認できる" do
        find(".navbar-toggler").click
        click_on "募集一覧"
        click_link "詳細", href: "/admin/rooms/#{room.id}"
        expect(page).to have_content("よろしく")
      end

      it "募集を削除できる" do
        find(".navbar-toggler").click
        click_on "募集一覧"
        click_link "詳細", href: "/admin/rooms/#{room.id}"
        click_link(href: "/admin/rooms/#{room.id}")
        accept_confirm do
          expect(page.driver.browser.switch_to.alert.text).to eq("削除しますか？")
        end
        expect(page).to have_content("募集を削除しました")
      end

      it "メッセージを削除できる" do
        find(".navbar-toggler").click
        click_on "募集一覧"
        click_link "詳細", href: "/admin/rooms/#{room.id}"
        click_link(href: "/admin/messages/#{message.id}")
        accept_confirm do
          expect(page.driver.browser.switch_to.alert.text).to eq("削除しますか？")
        end
        expect(page).to have_content("メッセージを削除しました")
      end

      it "タイトルで検索できる" do
        find(".navbar-toggler").click
        click_on "募集一覧"
        fill_in "q[title]", with: "テストゲーム募集"
        click_on "検索"
        expect(page).to have_content("テストゲーム募集")
      end

      it "ゲームで検索できる" do
        find(".navbar-toggler").click
        click_on "募集一覧"
        select "テストゲーム", from: "q[game]"
        click_on "検索"
        expect(page).to have_content("テストゲーム募集")
      end

      it "カテゴリで検索できる" do
        find(".navbar-toggler").click
        click_on "募集一覧"
        select "パーティー募集", from: "q[category]"
        expect(page).to have_content("テストゲーム募集")
      end
    end
  end
end
