class PermitsController < ApplicationController
  def create
    @room = Room.find(params[:room_id])
    if @room.permits.create(user: current_user)
      redirect_to rooms_path, success: t(".create")
    else
      redirect_to rooms_path, danger: t(".not_create")
    end
  end

  def destroy
    @permit = Permit.find(params[:id])
    if @permit.destroy
      redirect_to rooms_path, success: t(".destroy")
    else
      redirect_to rooms_path, danger: t(".not_destroy")
    end
  end

  def approve
    @room = Room.find(params[:room_id])
    @permit = Permit.find(params[:id])
    @user = @permit.user
    if @room.user_join_room(@user)
      @permit.destroy!
      redirect_to chat_board_room_path(@room), success: t(".approve")
    else
      redirect_to chat_board_room_path(@room), danger: t(".not_approve")
    end
  end

  def refuse
    @room = Room.find(params[:room_id])
    @permit = Permit.find(params[:id])
    if @permit.destroy
      redirect_to chat_board_room_path(@room), success: t(".refuse")
    else
      redirect_to chat_board_room_path(@room), danger: t(".not_refuse")
    end
  end
end
