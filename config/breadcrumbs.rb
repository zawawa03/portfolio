crumb :root do
  link "トップページ", root_path
end

crumb :user_new do
  link "新規登録", new_user_registration_path
end

crumb :profile_new do
  link "プロフィール作成", new_profile_path
  parent :user_new
end

crumb :user_login do
  link "ログイン", new_user_session_path
end

crumb :password_new do
  link "パスワードリセット申請", new_user_password_path
  parent :user_login
end

crumb :password_edit do
  link "パスワードリセット", edit_user_password_path
end

crumb :setting do
  link "設定", setting_path
  parent :root
end

crumb :agreement do
  link "利用規約", agreement_path
  parent :setting
end

crumb :privacy_policy do
  link "プライバシーポリシー", plivacy_policy_path
  parent :setting
end

crumb :new_contact do
  link "お問い合わせ", new_contact_path
  parent :setting
end

crumb :confirm_contact do
  link "お問い合わせ確認", contact_path
  parent :new_contact
end

crumb :notification do
  link "通知一覧", notifications_path
  parent :root
end

crumb :user_edit do
  link "ユーザー情報編集", edit_user_registration_path
  parent :setting
end

crumb :profile_show do |profile|
  link "#{profile.nickname}のプロフィール", user_profile_path(profile)
  parent :root
end

crumb :profile_edit do |profile|
  link "プロフィール編集", edit_profile_path
  parent :profile_show, profile
end

crumb :room_index do
  link "募集一覧", rooms_path
  parent :root
end

crumb :room_create do
  link "募集作成", new_room_path
  parent :room_index
end

crumb :room_show do |room|
  link "募集詳細", room_path(room)
  parent :room_index
end

crumb :room_edit do |room|
  link "募集編集", edit_room_path(room)
  parent :room_show, room
end

crumb :room_chat_board do |room|
  link "チャットルーム", chat_board_room_path(room)
  parent :room_index
end

crumb :room_search do
  link "検索結果", search_rooms_path
  parent :room_index
end

crumb :friend_chat do |room|
  link "フレンドチャット", friend_chat_path(room)
  parent :root
end

crumb :board_index do
  link "掲示板一覧", boards_path
  parent :root
end

crumb :board_new do
  link "掲示板作成", new_board_path
  parent :board_index
end

# crumb :projects do
#   link "Projects", projects_path
# end

# crumb :project do |project|
#   link project.name, project_path(project)
#   parent :projects
# end

# crumb :project_issues do |project|
#   link "Issues", project_issues_path(project)
#   parent :project, project
# end

# crumb :issue do |issue|
#   link issue.title, issue_path(issue)
#   parent :project_issues, issue.project
# end

# If you want to split your breadcrumbs configuration over multiple files, you
# can create a folder named `config/breadcrumbs` and put your configuration
# files there. All *.rb files (e.g. `frontend.rb` or `products.rb`) in that
# folder are loaded and reloaded automatically when you change them, just like
# this file (`config/breadcrumbs.rb`).
