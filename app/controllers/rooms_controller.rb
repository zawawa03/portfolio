class RoomsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[ index show ]

  def index
    @rooms = Room.includes(:creator)
  end

  def show
    @room = Room.find(params[:id])
  end

  def new
    @room = Room.new
  end

  def create
    @room = current_user.rooms.build(create_params)
    if @room.save
      redirect_to rooms_path, success: t(".create")
    else
      flash.now[:danger] = t(".not_create")
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def create_params
    params.require(:room).permit(:title, :body, :people)
  end
end
