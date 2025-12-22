class ContactsController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_action :profile_check

  def new
    @contact = Contact.new
  end

  def show
    @contact = Contact.new(contact_params)
  end

  def create
    @contact = Contact.new(contact_params)
    if @contact.save
      ContactNoticeMailer.with(contact: @contact).contact_notice.deliver_later
      redirect_to setting_path, success: t(".create")
    else
      flash.now[:danger] = t(".not_create")
      render :new
    end
  end

  private

  def contact_params
    params.require(:contact).permit(:email, :name, :body)
  end
end
