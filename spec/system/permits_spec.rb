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

    context "未ログイン時" do
      it "参加申請をしても無効" do
        visit room_path(room)
        click_on "参加申請"
        expect(page).to have_content("ログインもしくはアカウント登録してください。")
      end
    end

    context "募集詳細画面" do
      it "参加していない募集の詳細には参加申請ボタンがある" do
      end
      it "申請中の募集の詳細には申請取り消しの表記がある" do
      end
      it "参加人数が最大だと満員と表示される" do
      end
    end
  end
end
