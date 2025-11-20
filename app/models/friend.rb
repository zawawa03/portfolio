class Friend < ApplicationRecord
  belongs_to :leader, class_name: "User"
  belongs_to :follower, class_name: "User"

  validates :category, presence: true
  validate :not_double_friendship
  validates :leader_id, uniqueness: { scope: :follower_id }

  enum category: { apply: 0, friendship: 1, blocked: 2 }

  def not_double_friendship
    if Friend.exists?(leader_id: follower_id, follower_id: leader_id)
      errors.add(:base, "すでにフレンドかフレンド申請中です")
    end
  end

  def self.find_friends_user(user)
    leader_friends = where(follower: user, category: 1)
    follower_friends = where(leader: user, category: 1)

    leader_users = leader_friends.map { |friend| friend.leader }
    follower_users = follower_friends.map { |friend| friend.follower }

    leader_users + follower_users
  end

  def self.find_blocked_user(user, current_user)
    block_friends = where(leader: user, follower: current_user, category: 2)
    block_user = block_friends.map { |friend| friend.follower }
    block_user
  end
end
