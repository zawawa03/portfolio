class NotificationBroadcastJob < ApplicationJob
  queue_as :notification

  def perform(notification)
    ActionCable.server.broadcast("notification_#{notification.receiver_id}",
      { notification: render_notification(notification) }
      )
  end

  private

  def render_notification(notification)
    notifications_count = notification.receiver.receive_notifications.where(checked: false).size
    ApplicationController.renderer.render(partial: "shared/notification", locals: { notifications_count: notifications_count })
  end
end
