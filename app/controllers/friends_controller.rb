class FriendsController < ApplicationController
  def create
    @follower = User.find(params[:user_id])
    @friend = Friend.new(leader: @follower, follower: current_user)
    @notification = Notification.new(sender: current_user, receiver: @follower, category: 1)
    if @friend.save
      @notification.save
      redirect_to request.referer, success: t(".create")
    else
      redirect_to request.referer, danger: t(".not_create")
    end
  end

  def approve
    @friend = Friend.find(params[:id])
    @send_notification = Notification.new(sender: @friend.leader, receiver: @friend.follower, category: 2)
    @notification = Notification.find_by(sender: @friend.follower, receiver: @friend.leader, category: 1)
    @game = Game.find_by(name: "その他")
    @room = current_user.rooms.build(title: "friend_chat", people: 2, category: 1, game: @game)
    if @friend.update(category: 1)
      @send_notification.save
      if @notification.present?
        Rails.logger.info "Destroying notification #{@notification.id}"
        @notification.destroy!
      else
        Rails.logger.warn "Notification not found before destroy"
      end
      @room.save!
      @room.user_join_room(current_user)
      @room.user_join_room(@friend.follower)
      redirect_to notifications_path, success: t(".approve")
    else
      redirect_to notifications_path, danger: t(".not_approve")
    end
  end

  def refuse
    @friend = Friend.find(params[:id])
    @notification = Notification.find_by(sender: @friend.follower, receiver: @friend.leader, category: 1)
    if @friend.destroy
      @notification.destroy
      redirect_to notifications_path, success: t(".refuse")
    else
      redirect_to notifications_path, danger: t(".not_refuse")
    end
  end

  def chat_board
    @room = Room.find(params[:id])
    @users = @room.users
    @messages = @room.messages
  end

  def blocked
    @user = User.find(params[:user_id])
    @friend = current_user.find_friend(@user)
    if @friend
      if @friend.update(leader: @user, follower: current_user, category: 2)
        redirect_to request.referer || root_path, success: t(".blocked")
      else
        redirect_to request.referer || root_path, danger: t(".not_blocked")
      end
    else
      @block_friend = Friend.new(leader: @user, follower: current_user, category: 2)
      if @block_friend.save
        redirect_to request.referer || root_path, success: t(".blocked")
      else
        redirect_to request.referer || root_path, danger: t(".not_blocked")
      end
    end
  end  
end
