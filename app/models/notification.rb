class Notification < ApplicationRecord
  belongs_to :sender, class_name: "User"
  belongs_to :receiver, class_name: "User"

  validates :category, presence: true

  enum category: { room: 0, friend: 1 }

  def check_notification
    self.update!(checked: true) unless self.checked?
  end
end
