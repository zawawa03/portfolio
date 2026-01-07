require 'rails_helper'

RSpec.describe "Rooms", type: :system do
  include LoginMacros
  include CreateRoom
  describe "room機能" do
    let!(:user) { FactoryBot.create(:user, email: "user01@example.com") }
    let!(:profile) { FactoryBot.create(:profile, user: user) }
    let!(:game) { FactoryBot.create(:game, :with_picture) }
    let!(:room) { FactoryBot.create(:room, creator: user, game: game) }
    let!(:tag0) { FactoryBot.create(:tag) }
    let!(:tag1) { FactoryBot.create(:tag, :category_1) }
    let!(:tag2) { FactoryBot.create(:tag, :category_2) }
    let!(:user_room) { FactoryBot.create(:user_room, user: user, room: room) }

    context "未ログイン時" do
      it "未ログイン時は新規作成画面へアクセスできない" do
        visit rooms_path
        click_on "募集作成"
        expect(page).to have_content("ログインもしくはアカウント登録してください。")
      end
    end

    context "一覧機能" do
      before { login(user) }
      it "募集一覧リンクから一覧へアクセスできる" do
        click_on "パーティー募集"
        expect(page).to have_content("募集一覧")
      end

      it "一覧に募集が表示されている" do
        visit rooms_path
        expect(page).to have_content("テストゲーム募集")
      end
    end

    context "募集作成機能" do
      before { login(user) }
      it "一覧から新規作成画面へ遷移できる" do
        visit rooms_path
        click_on "募集作成"
        expect(page).to have_content("募集作成")
      end

      it "募集を作成できる" do
        visit rooms_path
        click_on "募集作成"
        fill_in "タイトル", with: room.title
        select "テストゲーム", from: "ゲームタイトル"
        select "3", from: "人数"
        choose "ゲームモードタグ"
        check "ゲームスタイルタグ"
        check "アビリティタグ"
        fill_in "詳細", with: room.body
        click_on "作成"
        expect(page).to have_content("募集を作成しました")
      end

      it "タイトルを入力しないとエラー" do
        visit rooms_path
        click_on "募集作成"
        fill_in "タイトル", with: nil
        select "テストゲーム", from: "ゲームタイトル"
        select "3", from: "人数"
        choose "ゲームモードタグ"
        check "ゲームスタイルタグ"
        check "アビリティタグ"
        fill_in "詳細", with: room.title
        click_on "作成"
        expect(page).to have_content("募集を作成できませんでした")
        expect(page).to have_content("タイトルを入力してください")
      end

      it "ゲームタイトルを選択しないとエラー" do
        visit rooms_path
        click_on "募集作成"
        fill_in "タイトル", with: room.title
        select "3", from: "人数"
        choose "ゲームモードタグ"
        check "ゲームスタイルタグ"
        check "アビリティタグ"
        fill_in "詳細", with: room.body
        click_on "作成"
        expect(page).to have_content("募集を作成できませんでした")
        expect(page).to have_content("ゲームタイトルを入力してください")
      end

      it "募集を作成するとチャットページへ遷移する" do
        visit rooms_path
        click_on "募集作成"
        fill_in "タイトル", with: room.title
        select "テストゲーム", from: "ゲームタイトル"
        select "3", from: "人数"
        choose "ゲームモードタグ"
        check "ゲームスタイルタグ"
        check "アビリティタグ"
        fill_in "詳細", with: room.body
        click_on "作成"
        expect(page).to have_content("チャットルーム")
      end

      it "作成した募集が一覧に表示されている" do
        room = FactoryBot.create(:room, creator: user, game: game, title: "テストルーム")
        create_room(room)
        visit rooms_path
        expect(page).to have_content("テストルーム")
      end
    end

    context "チャットページの機能" do # メッセージ送信系はmessageのテストでやる
      before { login(user) }

      it "退出ボタンを押すと退出できる" do
        create_room(room)
        click_on "退出"
        expect {
          expect(page.accept_confirm).to eq("退出しますか？参加者がいなくなると自動的に募集は削除されます")
          expect(page).to have_content("退出しました")
        }
      end

      it "退出が最後の一人ならその募集は削除される" do
        room = FactoryBot.build(:room, creator: user, game: game, title: "削除するルーム")
        create_room(room)
        accept_confirm("退出しますか？参加者がいなくなると自動的に募集は削除されます") do
          click_on "退出"
        end
        expect(page).to have_content("退出しました")
        expect(page).not_to have_content("削除するルーム")
      end

      it "編集ボタンから編集ページへ遷移できる" do
        create_room(room)
        click_on "編集"
        expect(page).to have_content("ルーム編集")
      end
    end

    context "編集機能" do
      before { login(user) }

      it "募集を編集できる" do
        visit edit_room_path(room)
        fill_in "タイトル", with: "編集したタイトル"
        click_on "更新"
        expect(page).to have_content("募集を編集しました")
      end

      it "編集でタイトルを入力しないとエラー" do
        visit edit_room_path(room)
        fill_in "タイトル", with: nil
        click_on "更新"
        expect(page).to have_content("募集を編集できませんでした")
        expect(page).to have_content("タイトルを入力してください")
      end
      it "編集するとチャットページへ遷移" do
        visit edit_room_path(room)
        fill_in "タイトル", with: "編集したタイトル"
        click_on "更新"
        expect(page).to have_content("チャットルーム")
      end
    end

    context "詳細機能" do # 承認系はpermitのテストでやる
      before { login(user) }

      it "一覧ページからリンクで詳細画面へアクセスできる" do
        user1 = FactoryBot.create(:user, last_name: "吉田", first_name: "沙織")
        profile1 = FactoryBot.create(:profile, nickname: "よし", user: user1)
        room1 = FactoryBot.create(:room, title: "よしの募集", creator: user1, game: game)
        visit rooms_path
        click_on "よしの募集"
        expect(page).to have_content("募集詳細")
        expect(page).to have_content("よしの募集")
      end

      it "募集に参加している場合はチャットルームへ遷移する" do
        visit rooms_path
        click_on("テストゲーム募集", match: :first)
        expect(page).to have_content("チャットルーム")
      end
    end

    context "検索機能" do
      it "キーワード検索ができる" do
        user1 = FactoryBot.create(:user, last_name: "吉田", first_name: "沙織")
        profile1 = FactoryBot.create(:profile, nickname: "よし", user: user1)
        room1 = FactoryBot.create(:room, title: "よしの募集", creator: user1, game: game)
        visit rooms_path
        fill_in "q[word]", with: "よし"
        expect(page).to have_content("よしの募集")
      end

      it "タグ検索ができる" do
        user1 = FactoryBot.create(:user, last_name: "吉田", first_name: "沙織")
        profile1 = FactoryBot.create(:profile, nickname: "よし", user: user1)
        room1 = FactoryBot.create(:room, title: "よしの募集", creator: user1, game: game)
        tag4 = FactoryBot.create(:tag, name: "セカンドモードタグ", category: 0)
        room_tag = FactoryBot.create(:room_tag, tag: tag4, room: room1)
        visit rooms_path
        select "セカンドモードタグ", from: "q[mode_tag]"
        expect(page).to have_content("よしの募集")
      end
    end
  end
end
