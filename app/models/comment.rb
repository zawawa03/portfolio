class Comment < ApplicationRecord
  has_many_attached :media

  belongs_to :board
  belongs_to :user, optional: true

  belongs_to :parent, class_name: "Comment", optional: true
  has_many :childrens, class_name: "Comment", foreign_key: "parent_id", dependent: :destroy

  validates :body, presence: true, length: { maximum: 255 }
  validates :media, media: { urge: true, content_type: %r{\Aimage/(png|jpeg)\Z}, maximum: 524_288_000 }
end
