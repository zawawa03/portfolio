class DeleteRoomJob
  include Sidekiq::Worker

  def perform
    rooms = Room.where(category: 0)
    rooms.where("created_at < ?", 12.hours.ago).find_each do |room|
      room.destroy
    end
    logger.info("delete_room_jobが実行されました")
  end
end
