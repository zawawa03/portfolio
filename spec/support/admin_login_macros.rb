module AdminLoginMacros
  def login_admin(user)
    visit admin_login_path
    fill_in "メールアドレス", with: user.email
    fill_in "パスワード", with: "password"
    click_on "ログイン"
  end
end
