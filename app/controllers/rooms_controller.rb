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
    @game_options = Game.game_option
    @mode_tag_options = Tag.where(category: 0)
    @style_tag_options = Tag.where(category: 1)
    @ability_tag_options = Tag.where(category: 2)
  end

  def create
    @room = current_user.rooms.build(create_params)
    if @room.save
      @room.room_tags.create(tag_id: @room.mode_tag_id) if @room.mode_tag_id.present?
      @room.room_tags.create(tag_id: @room.style_tag_id) if @room.style_tag_id.present?
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
    @room = Room.find(params[:id])
    if @room.destroy
      redirect_to rooms_path, success: t(".destroy")
    else
      falsh.now[:danger] = t(".not_destroy")
      redirect_to :back, damger: t(".not_destroy")
    end
  end

  private

  def create_params
    params.require(:room).permit(:title, :body, :people, :game_id ,:mode_tag_id, :style_tag_id, tag_ids: [])
  end
end
