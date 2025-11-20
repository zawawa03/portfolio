class Room < ApplicationRecord
  belongs_to :creator, class_name: "User"
  belongs_to :game
  has_many :room_tags, dependent: :destroy
  has_many :tags, through: :room_tags
  has_many :permits, dependent: :destroy
  has_many :user_rooms, dependent: :destroy
  has_many :users, through: :user_rooms
  has_many :permit_users, through: :permits, source: :user
  has_many :messages, dependent: :destroy

  attr_accessor :mode_tag_id

  validates :title, presence: true, length: { maximum: 50 }
  validates :body, length: { maximum: 255 }
  validates :people, presence: true, length: { in: 1..50 }

  enum category: { game: 0, friend: 1 }

  def user_join_room(user)
    users << user unless self.users.include?(user)
  end

  def find_permit(user)
    permits.find_by(user: user)
  end

  def self.find_friend_chat(user, current_user)
    Room.joins(:user_rooms).where(user_rooms: { user_id: [ user.id, current_user.id ] }).group("rooms.id").having("COUNT(DISTINCT user_rooms.user_id) = 2").where(category: 1).first
  end

  def have_blocked_user?(current_user)
    blocked_users = []
    self.users.each do |user|
      if Friend.find_blocked_user(user, current_user).present?
        blocked_users << user
      end
    end
    blocked_users.present?
  end
end
