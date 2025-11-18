class NotificationsController < ApplicationController
  def index
    @notifications = Notification.where(receiver: current_user).order(created_at: :DESC).page(params[:page]).per(6)
    @notifications.each do |notification|
      notification.check_notification
    end
  end
end
