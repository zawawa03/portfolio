class PermitBroadcastJob < ApplicationJob
  queue_as :permit

  def perform(permit)
    ActionCable.server.broadcast("room_permit_#{permit.room_id}",
    { permit: render_permit(permit),
      button: render_button(permit),
      creator_id: permit.room.creator_id,
      permit_id: permit.id
    })
  end

  private

  def render_permit(permit)
    ApplicationController.renderer.render(partial: "rooms/permit", locals: { permit: permit })
  end

  def render_button(permit)
    ApplicationController.renderer.render(partial: "rooms/permit_button", locals: { permit: permit })
  end
end
