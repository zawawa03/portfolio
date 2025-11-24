class Contact < ApplicationRecord
  validates :email, presence: true
  validates :name, presence: true
  validates :body, presence: true, length: { maximum: 1000 }
end
