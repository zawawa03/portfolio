class Notification < ApplicationRecord
  after_create_commit { NotificationBroadcastJob.perform_later self }

  belongs_to :sender, class_name: "User"
  belongs_to :receiver, class_name: "User"

  validates :category, presence: true

  enum category: { room: 0, friend_apply: 1, friend_permit: 2 }

  def check_notification
    self.update!(checked: true) unless self.checked?
  end

  def search_friend
    @friend = Friend.find_by(follower: self.sender, leader: self.receiver)
  end
end
