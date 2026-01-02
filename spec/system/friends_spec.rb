require 'rails_helper'

RSpec.describe "Friends", type: :system do
  include LoginMacros
  include CreateRoom

  describe "フレンド機能" do
    let!(:user) { FactoryBot.create(:user) }
    let!(:user2) { FactoryBot.create(:user, first_name: "ゆうと", last_name: "吉田") }
    let!(:profile) { FactoryBot.create(:profile, user: user) }
    let!(:profile2) { FactoryBot.create(:profile, nickname: "ゆうと", user: user2) }

    context "未ログイン時" do
      it "サイドバーにフレンド一覧が表示されない" do
        visit root_path
        expect(page).not_to have_content("フレンド一覧")
      end
    end

    context "ログイン時" do
      let!(:game) { FactoryBot.create(:game, :with_picture) }
      let!(:room) { FactoryBot.create(:room, creator: user, game: game) }
      let!(:user_room) { FactoryBot.create(:user_room, user: user, room: room) }
      let!(:user_room2) { FactoryBot.create(:user_room, user: user2, room: room) }

      it "フレンド一覧が表示される" do
        login(user)
        expect(page).to have_content("フレンド一覧")
      end

      it "フレンド状態のユーザーがフレンド一覧に表示される" do
        friend = FactoryBot.create(:friend, :friendship, leader: user, follower: user2)
        room = FactoryBot.create(:room, category: 1, creator: user, game: game)
        user_room = FactoryBot.create(:user_room, user: user, room: room)
        user_room2 = FactoryBot.create(:user_room, user: user2, room: room)
        login(user)
        within("#friend-index") do
          expect(page).to have_content("ゆうと")
        end
      end

      it "ユーザーにフレンド申請できる" do
        login(user)
        visit chat_board_room_path(room)
        find(:css, "span#user-dropdown", text: "ゆうと").click
        click_link(href: "/friends/#{user2.id}")
        expect(page).to have_content("フレンド申請しました")
      end

      it "フレンド申請されたユーザーが承認するとフレンドになる" do
        notification = FactoryBot.create(:notification, :friend_app, sender: user2, receiver: user)
        friend = FactoryBot.create(:friend, leader: user, follower: user2)
        login(user)
        visit notifications_path
        click_on "承認"
        expect("フレンドになりました")
      end

      it "フレンドをブロックできる" do
        friend = FactoryBot.create(:friend, :friendship, leader: user, follower: user2)
        room = FactoryBot.create(:room, category: 1, creator: user, game: game)
        user_room = FactoryBot.create(:user_room, user: user, room: room)
        user_room2 = FactoryBot.create(:user_room, user: user2, room: room)
        login(user)
        visit root_path
        find(:css, "span#nickname", text: "ゆうと").click
        click_link(href: "/friend/#{user2.id}")
        accept_confirm do
          expect(page.driver.browser.switch_to.alert.text).to eq("本当にブロックしますか？")
        end
        expect(page).to have_content("ユーザーをブロックしました")
      end

      it "ブロックされているユーザーはフレンド一覧に表示されない" do
        friend = FactoryBot.create(:friend, :blocked, leader: user, follower: user2)
        login(user)
        visit root_path
        expect(page).not_to have_content("ゆうと")
      end

      it "ブロックしたユーザーがいる募集に参加申請しようとすると確認が出る" do
        friend = FactoryBot.create(:friend, :blocked, leader: user, follower: user2)
        room2 = FactoryBot.create(:room, creator: user2, game: game)
        user_room3 = FactoryBot.create(:user_room, user: user2, room: room2)
        login(user)
        visit room_path(room2)
        click_on "参加申請"
        expect {
          expect(page).to have_content("ブロックしているユーザーが参加者にいます。参加申請しますか？")
        }
      end

      it "フレンドチャットページにアクセスできる" do
        friend = FactoryBot.create(:friend, :friendship, leader: user, follower: user2)
        room = FactoryBot.create(:room, category: 1, creator: user, game: game)
        user_room = FactoryBot.create(:user_room, user: user, room: room)
        user_room2 = FactoryBot.create(:user_room, user: user2, room: room)
        login(user)
        find(:css, "span#nickname", text: "ゆうと").click
        click_link(href: "/friends/#{room.id}")
        expect(page).to have_content("フレンドチャット")
      end

      it "メッセージを送信できる", js: true do
        friend = FactoryBot.create(:friend, :friendship, leader: user, follower: user2)
        room = FactoryBot.create(:room, category: 1, creator: user, game: game)
        user_room = FactoryBot.create(:user_room, user: user, room: room)
        user_room2 = FactoryBot.create(:user_room, user: user2, room: room)
        login(user)
        visit friend_chat_path(room)
        fill_in "message", with: "こんにちは"
        find("input[name='message']").send_keys(:enter)
        within("#message-field") do
          expect(page).to have_content("こんにちは")
        end
      end
    end
  end
end
