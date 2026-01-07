require "rails_helper"

RSpec.describe ContactNoticeMailer, type: :mailer do
  describe "お問い合わせメール確認" do
    let!(:contact) { FactoryBot.create(:contact) }
    let!(:mail) { ContactNoticeMailer.with(contact: contact).contact_notice }

    context "メールが送信された時"  do
      it "ヘッダーが正しい" do
        expect(mail.subject).to eq("お問い合わせ通知")
        expect(mail.to).to eq([ "yszw3711hg@gmail.com" ])
        expect(mail.from).to eq([ "gamers-room" ])
      end

      it "メール本文が正しい" do
        expect(mail.text_part.body.encoded).to match("新しいお問い合わせがあります")
        expect(mail.text_part.body.encoded).to match(admin_contact_url(contact))
      end
    end
  end
end
