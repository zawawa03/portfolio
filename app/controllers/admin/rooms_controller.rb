class Admin::RoomsController < Admin::BaseController
  def index
    @rooms = Room.includes(:creator)
  end

  def show
    @room = Room.find(params[:id])
    @users = @room.users
    @messages = @room.messages
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

  def search
    @room_search = AdminRoomSearchForm.new(search_params)
    @rooms = @room_search.result
  end

  private

  def search_params
    params.require(:q).permit(:title, :category, :game, :sort)
  end
end
