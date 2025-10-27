class Admin::RoomsController < Admin::BaseController
  def index
    @rooms = Room.includes(:creator)
  end

  def show
    @room = Room.find(params[:id])
  end

  def destroy
    @room = Room.find(params[:id])
    @room.destroy!
    redirect_to admin_rooms_path, success: t(".destroy")
  end
end
