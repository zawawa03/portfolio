module SendResetPasswordMail
  def send_reset_mail(user)
    visit new_user_password_path
    fill_in "メールアドレス", with: user.email
    click_on "再設定メール送信"
  end
end
