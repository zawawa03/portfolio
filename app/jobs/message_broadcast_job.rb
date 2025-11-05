class MessageBroadcastJob < ApplicationJob
  queue_as :chat

  def perform(message)
    ActionCable.server.broadcast("room_#{message.room_id}", { message: render_message(message) })
  end

  private

  def render_message(message)
    ApplicationController.renderer.render(partial: "rooms/message", locals: { message: message })
  end
end
