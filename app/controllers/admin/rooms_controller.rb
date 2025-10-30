class Admin::RoomsController < Admin::BaseController
  def index
    @rooms = Room.includes(:creator)
  end

  def show
    @room = Room.find(params[:id])
    @users = @room.users
  end

  def destroy
    @room = Room.find(params[:id])
    if @room.destroy
      redirect_to admin_rooms_path, success: t(".destroy")
    else
      flash.now[:danger] = t(".not_destroy")
      render :index, status: :unprocrssable_entity
    end
  end
end
