class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :profile, dependent: :destroy
  has_many :rooms, class_name: "Room", foreign_key: "creator_id", dependent: :destroy
  has_many :permits, dependent: :destroy
  has_many :user_rooms, dependent: :destroy
  has_many :send_notifications, class_name: "Notification", foreign_key: "sender_id", dependent: :destroy
  has_many :receive_notifications, class_name: "Notification", foreign_key: "receiver_id", dependent: :destroy
  has_many :leader_friends, class_name: "Friend", foreign_key: "leader_id", dependent: :destroy
  has_many :follower_friends, class_name: "Friend", foreign_key: "follower_id", dependent: :destroy
  has_many :messages

  validates :password, length: { minimum: 6 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }
  validates :first_name, presence: true, length: { maximum: 255 }
  validates :last_name, presence: true, length: { maximum: 255 }
  validates :email, presence: true, uniqueness: true
  validates :role, presence: true
  validates :uid, presence: true, uniqueness: { scope: :provider }, if: -> { uid.present? }

  enum role: { general: 0, admin: 1 }
end
