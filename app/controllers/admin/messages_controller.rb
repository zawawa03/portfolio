class Admin::MessagesController < Admin::BaseController
  def destroy
    @message = Message.find(params[:id])
    @room = @message.room
    if @message.destroy
      redirect_to admin_room_path(@room), success: t(".destroy")
    else
      redirect_to admin_room_path(@room), danger: t(".not_destroy")
    end
  end
end