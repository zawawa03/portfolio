class RoomsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[ index show ]
  before_action :set_options, only: %i[ new create edit update ]

  def index
    @rooms = Room.includes(:creator).where(category: 0)
  end

  def show
    @room = Room.find(params[:id])
  end

  def new
    @room = Room.new
  end

  def create
    @room = current_user.rooms.build(room_params)
    if @room.save
      @room.room_tags.create(tag_id: @room.mode_tag_id) if @room.mode_tag_id.present?
      @room.user_join_room(current_user)
      redirect_to rooms_path, success: t(".create")
    else
      flash.now[:danger] = t(".not_create")
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @room = Room.find(params[:id])
  end

  def update
    @room = Room.find(params[:id])
    if @room.update(room_params)
      begin
        ActiveRecord::Base.transaction do
          @room.room_tags.destroy_all
          @room.room_tags.create(tag_id: @room.mode_tag_id) if @room.mode_tag_id.present?
          if @room.tag_ids.present?
            @room.tag_ids.each do |tag|
              @room.room_tags.create(tag_id: tag)
            end
          end
        end
        rescue => e
          flash.now[:danger] = t(".not_edit")
          render :edit, status: :unprocessable_entity
      end

      redirect_to rooms_path, success: t(".did_edit")
    else
      flash.now[:danger] = t(".not_edit")
      render :edit, status: :unprocessable_entity
    end
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

  def chat_board
    @room = Room.find(params[:id])
    @users = @room.users
    @permits = @room.permits
    @messages = @room.messages
    @room.user_join_room(current_user)
  end

  private

  def room_params
    params.require(:room).permit(:title, :body, :people, :game_id, :mode_tag_id, tag_ids: [])
  end

  def set_options
    @game_options = Game.game_option
    @mode_tag_options = Tag.search(0)
    @style_tag_options = Tag.search(1)
    @ability_tag_options = Tag.search(2)
  end
end
