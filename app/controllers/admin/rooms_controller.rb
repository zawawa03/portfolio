class Admin::RoomsController < Admin::BaseController
  def index
    @rooms = Room.includes(:creator)
  end

  def show
    @room = Room.find(params[:id])
  end
end
