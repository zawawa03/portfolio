class Tag < ApplicationRecord
  has_many :room_tags
  has_many :rooms, through: :room_tags

  validates :name, presence: true, length: { maximum: 20 }
  validates :category, presence: true

  enum category: { mode: 0, style: 1, ability: 2 }

  def self.search(category)
    where(category: category)
  end
end
