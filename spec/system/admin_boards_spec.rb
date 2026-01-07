require 'rails_helper'

RSpec.describe "AdminBoards", type: :system do
  include AdminLoginMacros

  describe "管理画面" do
    let!(:user) { FactoryBot.create(:user, email: "user_01@example.com", role: "admin") }
    let!(:profile) { FactoryBot.create(:profile, user: user) }
    let!(:game) { FactoryBot.create(:game, :with_picture) }
    let!(:board) { FactoryBot.create(:board, creator: user, game: game) }
    let!(:comment) { FactoryBot.create(:comment, board: board, user: user) }

    before { login_admin(user) }

    context "掲示板機能" do
      it "掲示板一覧にアクセスできる" do
        find(".navbar-toggler").click
        click_on "掲示板一覧"
        expect(page).to have_content("掲示板一覧")
      end

      it "掲示板詳細にアクセスできる" do
        find(".navbar-toggler").click
        click_on "掲示板一覧"
        click_link "詳細", href: "/admin/boards/#{board.id}"
        expect(page).to have_content("掲示板詳細")
        expect(page).to have_content("テスト掲示板")
      end

      it "コメントを確認できる" do
        find(".navbar-toggler").click
        click_on "掲示板一覧"
        click_link "詳細", href: "/admin/boards/#{board.id}"
        expect(page).to have_content("よろしく")
      end

      it "コメントを削除できる" do
        find(".navbar-toggler").click
        click_on "掲示板一覧"
        click_link "詳細", href: "/admin/boards/#{board.id}"
        accept_confirm("コメントを削除しますか？") do
          click_link "削除", href: "/admin/boards/#{board.id}/comments/#{comment.id}"
        end
        expect(page).to have_content("コメントを削除しました")
      end

      it "掲示板を削除できる" do
        find(".navbar-toggler").click
        click_on "掲示板一覧"
        click_link "詳細", href: "/admin/boards/#{board.id}"
        accept_confirm("掲示板を削除しますか？") do
          click_link "削除", href: "/admin/boards/#{board.id}"
        end
        expect(page).to have_content("掲示板を削除しました")
      end

      it "タイトルで検索できる" do
        find(".navbar-toggler").click
        click_on "掲示板一覧"
        fill_in "q[title]", with: "テスト掲示板"
        click_on "検索"
        expect(page).to have_content("テスト掲示板")
      end

      it "ゲームで検索できる" do
        find(".navbar-toggler").click
        click_on "掲示板一覧"
        select "テストゲーム", from: "q[game]"
        click_on "検索"
        expect(page).to have_content("テスト掲示板")
      end
    end
  end
end
