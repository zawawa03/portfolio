class Admin::ContactsController < Admin::BaseController
  def index
    @contacts = Contact.all.order(created_at: :DESC)
  end

  def show
    @contact = Contact.find(params[:id])
  end

  def destroy
    @contact = Contact.find(params[:id])
    if @contact.destroy
      redirect_to admin_contacts_path, success: t(".delete")
    else
      redirect_to admin_contacts_path, danger: t(".not_delete")
    end
  end
end
