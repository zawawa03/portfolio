class FriendsController < ApplicationController
  def create
    @follower = User.find(params[:user_id])
    @friend = Friend.new(leader: @follower, follower: current_user)
    @notification = Notification.new(sender: current_user, receiver: @follower, category: 1)
    if @friend.save
      @notification.save
      redirect_to request.referer, success: t(".create")
    else
      redirect_to request.referer, flash: {
        danger: @friend.errors.present? ? @friend.errors.full_messages.join(", ") : t(".not_create")
      }
    end
  end

  def approve
    @friend = Friend.find(params[:id])
    @send_notification = Notification.new(sender: @friend.leader, receiver: @friend.follower, category: 2)
    @notification = Notification.find_by(sender: @friend.follower, receiver: @friend.leader, category: 1)
    if @friend.update(category: 1)
      @send_notification.save
      @notification.destroy
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
end
