require 'rails_helper'

RSpec.describe "Boards", type: :system do
  include LoginMacros

  describe "掲示板機能" do
    let!(:user) { FactoryBot.create(:user, email: "user_01@example.com") }
    let!(:profile) { FactoryBot.create(:profile, user: user) }
    let!(:game) { FactoryBot.create(:game, :with_picture) }
    let!(:board) { FactoryBot.create(:board, creator: user, game: game) }

    context "未ログイン時" do
      it "一覧にアクセスできる" do
        visit boards_path
        expect(page).to have_content("掲示板一覧")
      end

      it "一覧に掲示板が生じされる" do
        visit boards_path
        expect(page).to have_content("テスト掲示板")
      end

      it "詳細ページにアクセスできる" do
        visit boards_path
        click_on "テスト掲示板"
        within("#board_show") do
          expect(page).to have_content("テスト掲示板")
        end
      end

      it "コメントできる" do
        visit board_path(board)
        fill_in "comment[body]", with: "テストコメント"
        click_on "送信"
        within("#comment_field") do
          expect(page).to have_content("テストコメント")
        end
      end

      it "画像付きでコメントできる" do
        visit board_path(board)
        fill_in "comment[body]", with: "テストコメント"
        attach_file("comment[media][]", Rails.root.join("spec/fixtures/files/image/test_png.png"))
        click_on "送信"
        within("#comment_field") do
          expect(page).to have_content("テストコメント")
          expect(page).to have_selector("img[src$='test_png.png']")
        end
      end

      it "返信ボタンを押すと返信フォームが表示される" do
        comment = FactoryBot.create(:comment, board: board, user: user)
        visit board_path(board)
        within("#comment") do
          click_on "返信"
        end
        expect(page).to have_content("閉じる")
      end

      it "コメントに返信できる" do
        comment = FactoryBot.create(:comment, board: board, user: user)
        visit board_path(board)
        within("#comment") do
          click_on "返信"
        end
        within (".reply-form") do
          fill_in "comment[body]", with: "返信テスト"
        end
        within(".reply-form") do
          click_on "返信"
        end
        within("#comment_field") do
          expect(page).to have_content("返信テスト")
        end
      end

      it "コメント送信者が名無しになっている" do
        visit board_path(board)
        fill_in "comment[body]", with: "テストコメント"
        click_on "送信"
        within("#comment") do
          expect(page).to have_content("名無し")
        end
      end

      it "掲示板新規作成ページにはログインが必要" do
        visit boards_path
        click_on "掲示板作成"
        expect(page).to have_content("ログインもしくはアカウント登録してください。")
      end
    end

    context "新規作成画面" do
      it "新規作成画面にアクセスできる" do
        login(user)
        visit boards_path
        click_on "掲示板作成"
        expect(page).to have_content("掲示板作成")
      end

      it "掲示板を作成できる" do
        login(user)
        visit new_board_path
        fill_in "タイトル", with: "作成した掲示板"
        select "テストゲーム", from: "ゲームタイトル"
        click_on "作成"
        expect(page).to have_content("掲示板を作成しました")
        expect(page).to have_content("作成した掲示板")
      end

      it "タイトルを入力しないとエラー" do
        login(user)
        visit new_board_path
        select "テストゲーム", from: "ゲームタイトル"
        click_on "作成"
        expect(page).to have_content("掲示板を作成できませんでした")
      end

      it "ゲームタイトルを選択しないとエラー" do
        login(user)
        visit new_board_path
        fill_in "タイトル", with: "作成した掲示板"
        click_on "作成"
        expect(page).to have_content("掲示板を作成できませんでした")
      end
    end

    context "一覧画面" do
      it "掲示板を削除できる" do
        login(user)
        visit boards_path
        click_on "削除"
        accept_confirm do
          expect(page.driver.browser.switch_to.alert.text).to eq("掲示板を削除しますか？")
        end
        expect(page).to have_content("掲示板を削除しました")
      end
    end

    context "詳細画面" do
      it "コメント送信者はニックネームが表示される" do
        login(user)
        visit board_path(board)
        fill_in "comment[body]", with: "テストコメント"
        click_on "送信"
        within("#comment") do
          expect(page).to have_content("らんてくん")
        end
      end
    end

    context "検索機能" do
      it "キーワード検索ができる" do
        visit boards_path
        fill_in "q[word]", with: "テスト掲示板"
        click_on "検索"
        expect(page).to have_content("テスト掲示板")
      end

      it "タグ検索ができる" do
        tag1 = FactoryBot.create(:tag, :category_3)
        board_tag = FactoryBot.create(:board_tag, tag: tag1, board: board)
        visit boards_path
        select "掲示板タグ", from: "q[tag_id]"
        click_on "検索"
        expect(page).to have_content("テスト掲示板")
      end
    end
  end
end
