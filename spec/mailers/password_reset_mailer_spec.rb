require "rails_helper"

RSpec.describe Devise::Mailer, type: :mailer do
  describe "reset_password_instructions" do
    let!(:user) { FactoryBot.create(:user, email: "user001@example.com") }
    let!(:token) { "reset_token" }
    let!(:mail) { Devise::Mailer.reset_password_instructions(user, token, {}) }

    it "ヘッダーが正しい" do
      expect(mail.subject).to eq("パスワードの再設定について")
      expect(mail.to).to eq([ "#{user.email}" ])
      expect(mail.from).to eq([ "gamers-room" ])
    end

    it "メール本文が正しい" do
      expect(mail.body.encoded).to include("#{user.email}様")
      expect(mail.body.encoded).to include("下記のリンクからパスワードの再設定を行ってください")
      expect(mail.body.encoded).to include(edit_user_password_url)
    end

    it "本文にトークンが含まれる" do
      expect(mail.body.encoded).to include(token)
    end
  end
end
