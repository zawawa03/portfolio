class RoomChannel < ApplicationCable::Channel
  def subscribed
    stream_from "room_#{params[:room][:id]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def speak(data)
    Message.create!(body: data["message"], user: current_user, room_id: params[:room][:id])
  end
end
