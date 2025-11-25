class ContactNoticeMailer < ApplicationMailer
  def contact_notice
    @contact = params[:contact]
    @url = admin_contact_url(@contact)
    mail(to: "yszw3711hg@gmail.com", subject: "お問い合わせ通知")
  end
end
