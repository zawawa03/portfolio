class Message < ApplicationRecord
  after_create_commit { MessageBroadcastJob.perform_later self }

  belongs_to :room
  belongs_to :user

  validates :body, presence: true, length: { maximum: 255 }

  def message_nickname
    user.profile.nickname
  end
end
