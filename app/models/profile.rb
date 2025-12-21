class Profile < ApplicationRecord
  belongs_to :user

  has_one_attached :avatar

  validates :nickname, presence: true, length: { maximum: 30 }, uniqueness: true
  validates :sex, presence: true
  validates :introduction, length: { maximum: 255 }
  validates :avatar, image: { purge: true, content_type: %r{\Aimage/(png|jpeg)\Z}, maximum: 524_288_000 }

  enum sex: { hidden: 0, male: 1, female: 2 }
end
