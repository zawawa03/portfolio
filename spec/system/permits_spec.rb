require 'rails_helper'

RSpec.describe "Permits", type: :system do
  include LoginMacros
  include CreateRoom
  describe "承認機能" do
    let!(:user) { FactoryBot.create(:user) }
    let!(:profile) { FactoryBot.create(:profile, user: user) }
    let!(:game) { FactoryBot.create(:game, :with_picture) }
    let!(:room) { FactoryBot.create(:room, creator: user, game: game) }
    let!(:user_room) { FactoryBot.create(:user_room, user: user, room: room) }
    let!(:user2) { FactoryBot.create(:user, first_name: "ゆうと", last_name: "吉田") }
    let!(:profile2) { FactoryBot.create(:profile, nickname: "ゆうと", user: user2) }

    context "未ログイン時" do
      it "参加申請をしても無効" do
        visit room_path(room)
        click_on "参加申請"
        expect(page).to have_content("ログインもしくはアカウント登録してください。")
      end
    end

    context "募集詳細画面" do
      it "参加していない募集の詳細には参加申請ボタンがある" do
        login(user2)
        visit room_path(room)
        expect(page).to have_content("参加申請")
      end

      it "参加申請できる" do
        login(user2)
        visit room_path(room)
        click_on "参加申請"
        expect(page).to have_content("参加申請をしました")
      end

      it "申請中の募集の詳細には申請取り消しの表記がある" do
        login(user2)
        visit room_path(room)
        click_on "参加申請"
        visit room_path(room)
        expect(page).to have_content("申請取り消し")
      end

      it "参加人数が最大だと満員と表示される" do
        room2 = FactoryBot.create(:room, people: 1, creator: user, game: game)
        user_room2 = FactoryBot.create(:user_room, user: user, room: room2)
        visit room_path(room2)
        expect(page).to have_content("満員")
      end
    end

    context "チャットページ" do
      it "参加申請しているユーザーが申請者欄に表示される" do
        user_room2 = FactoryBot.create(:user_room, user: user2, room: room)
        login(user)
        visit chat_board_room_path(room)
        expect(page).to have_content("ゆうと")
      end

      it "募集の作成者が承認ボタンを押すと参加者に追加される" do
        permit = FactoryBot.create(:permit, user: user2, room: room)
        login(user)
        visit chat_board_room_path(room)
        click_on "承認"
        within("#user-list") do
          expect(page).to have_content("ゆうと")
        end
      end

      it "募集の作成者が拒否ボタンを押すと申請者欄から消される" do
        permit = FactoryBot.create(:permit, user: user2, room: room)
        login(user)
        visit chat_board_room_path(room)
        click_on "拒否"
        expect(page).not_to have_content("ゆうと")
      end

      it "募集の作成者にのみ承認、拒否ボタンが表示される" do
        user_room2 = FactoryBot.create(:user_room, user: user2, room: room)
        user3 = FactoryBot.create(:user, first_name: "佐藤", last_name: "かずと")
        profile3 = FactoryBot.create(:profile, nickname: "かずと", user: user3)
        permit = FactoryBot.create(:permit, user: user3, room: room)
        login(user)
        visit chat_board_room_path(room)
        expect(page).to have_content("承認")
        expect(page).to have_content("拒否")
      end

      it "募集の作成者以外には承認、拒否ボタンは表示されない" do
        user_room2 = FactoryBot.create(:user_room, user: user2, room: room)
        user3 = FactoryBot.create(:user, first_name: "佐藤", last_name: "かずと")
        profile3 = FactoryBot.create(:profile, nickname: "かずと", user: user3)
        permit = FactoryBot.create(:permit, user: user3, room: room)
        login(user2)
        visit chat_board_room_path(room)
        expect(page).not_to have_content("承認")
        expect(page).not_to have_content("拒否")
      end
    end
  end
end
