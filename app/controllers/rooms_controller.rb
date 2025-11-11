class RoomsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[ index show ]
  before_action :set_options, only: %i[ new create edit update index search ]

  def index
    @rooms = Room.includes(:creator).where(category: 0)
  end

  def show
    @room = Room.find(params[:id])
    set_meta_tags(
      title: @room.title,
      description: "#{@room.creator.profile.nickname}さんのパーティー募集",
      og: {
        title: @room.title,
        description: "#{@room.creator.profile.nickname}さんのパーティー募集",
        url: room_path(@room),
        image: url_for(@room.game.picture)
      },
      twitter: {
        image: url_for(@room.game.picture)
      }
    )
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
    set_meta_tags(
      title: @room.title,
      description: "#{@room.creator.profile.nickname}さんのパーティー募集",
      og: {
        title: @room.title,
        description: "#{@room.creator.profile.nickname}さんのパーティー募集",
        url: room_path(@room),
        image: url_for(@room.game.picture)
      },
      twitter: {
        title: @room.title,
        description: "#{@room.creator.profile.nickname}さんのパーティー募集",
        url: room_path(@room),
        image: url_for(@room.game.picture)
      }
    )
  end

  def leave
    @room = Room.find(params[:id])
    @user_room = UserRoom.find_by(user: current_user, room: @room)
    if @user_room&.destroy
      @room.destroy if @room.users.empty?
      redirect_to rooms_path, success: t(".leave")
    else
      flash.now[:danger] = t(".not_leave")
      render :chat_board, status: :unprocessable_entity
    end
  end

  def search
    @result = RoomSearchForm.new(search_params)
    @rooms = @result.result
  end

  private

  def room_params
    params.require(:room).permit(:title, :body, :people, :game_id, :mode_tag_id, tag_ids: [])
  end

  def search_params
    params.require(:q).permit(:word, :mode_tag, :style_tag, :ability_tag)
  end

  def set_options
    @game_options = Game.game_option
    @mode_tag_options = Tag.search(0)
    @style_tag_options = Tag.search(1)
    @ability_tag_options = Tag.search(2)
  end
end
