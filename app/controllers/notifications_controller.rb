class NotificationsController < ApplicationController
  def index
    @notifications = Notification.where(receiver: current_user)
    @notifications.each do |notification|
      notification.check_notification
    end
  end
end
