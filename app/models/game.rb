class Game < ApplicationRecord
  has_many :rooms, dependent: :destroy

  has_one_attached :picture

  validates :name, presence: true
  validates :picture, image: { urge: true, content_type: %r{\Aimage/(png|jpeg)\Z}, maximum: 524_288_000 }
end
