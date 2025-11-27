class Board < ApplicationRecord
  belongs_to :creator, class_name: "User"
  belongs_to :game
  has_many :board_tags, dependent: :destroy
  has_many :tags, through: :board_tags
  has_many :comments, dependent: :destroy

  validates :title, presence: true, length: { maximum: 255 }
end
