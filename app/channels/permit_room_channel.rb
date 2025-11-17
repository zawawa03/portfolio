class PermitRoomChannel < ApplicationCable::Channel
  def subscribed
    stream_from "room_permit_#{params[:room][:id]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
