require 'rails_helper'

RSpec.describe "Rooms", type: :system do
  include LoginMacros
  include CreateRoom
  describe "room機能" do
    let!(:user) { FactoryBot.create(:user) }
    let!(:profile) { FactoryBot.create(:profile, user: user) }
    let!(:game) { FactoryBot.create(:game, :with_picture) }
    let!(:room) { FactoryBot.create(:room, creator: user, game: game) }
    let!(:tag0) { FactoryBot.create(:tag) }
    let!(:tag1) { FactoryBot.create(:tag, :category_1) }
    let!(:tag2) { FactoryBot.create(:tag, :category_2) }

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
        expect(page).to have_content("テストゲーム")
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
  end
end
