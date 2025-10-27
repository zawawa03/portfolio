class Room < ApplicationRecord
  belongs_to :creator, class_name: "User"
  belongs_to :game
  has_many :room_tags

  validates :title, presence: true, length: { maximum: 50 }
  validates :body, length: { maximum: 255 }
  validates :people, presence: true, length: { in: 1..50 }
end
