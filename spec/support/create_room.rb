module CreateRoom
  def create_room(room)
    visit new_room_path
    fill_in "タイトル", with: room.title
    select "テストゲーム", from: "ゲームタイトル"
    select "3", from: "人数"
    choose "ゲームモードタグ"
    check "ゲームスタイルタグ"
    check "アビリティタグ"
    fill_in "詳細", with: room.body
    click_on "作成"
  end
end
