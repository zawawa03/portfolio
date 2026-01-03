require 'rails_helper'

RSpec.describe "Boards", type: :system do
  include LoginMacros

  describe "掲示板機能" do
    let!(:user) { FactoryBot.create(:user) }
    let!(:profile) { FactoryBot.create(:profile, user: user) }
    let!(:game) { FactoryBot.create(:game, :with_picture) }
    let!(:board) { FactoryBot.create(:board, creator: user, game: game) }

    context "未ログイン時" do
      it "一覧にアクセスできる" do
      end
      it "一覧に掲示板が生じされる" do
      end
      it "詳細ページにアクセスできる" do
      end
      it "コメントできる" do
      end
      it "画像付きでコメントできる" do
      end
      it "コメントに返信できる" do
      end
      it "コメント送信者が名無しになっている" do
      end
      it "掲示板新規作成ページにはログインが必要" do
      end
    end

    context "新規作成画面" do
      it "新規作成画面にアクセスできる" do
      end

      it "掲示板を作成できる" do
      end

      it "タイトルを入力しないと作成できない" do
      end
    end

    context "一覧画面" do
      it "掲示板を削除できる" do
      end
    end

    context "詳細画面" do
      it "コメント送信者はニックネームが表示される" do
      end
    end

    context "検索機能" do
    end
  end
end
