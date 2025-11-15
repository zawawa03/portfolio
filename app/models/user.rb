class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [ :google_oauth2 ]

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
  validates :first_name,  length: { maximum: 255 }
  validates :last_name,  length: { maximum: 255 }
  validate :first_name_cannot_be_nil
  validate :last_name_cannot_be_nil
  validates :email, presence: true, uniqueness: true
  validates :role, presence: true
  validates :uid, presence: true, uniqueness: { scope: :provider }, if: -> { uid.present? }

  enum role: { general: 0, admin: 1 }

  def first_name_cannot_be_nil
    errors.add(:first_name, "can't be nil") if first_name.nil?
  end

  def last_name_cannot_be_nil
    errors.add(:last_name, "can't be nil") if last_name.nil?
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      names = auth.info.name.split(" ", 2)
      user.last_name = names[0]
      user.first_name = names[1] || ""
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.password_confirmation = user.password
    end
  end

  def self.create_unique_string
    SecureRandom.uuid
  end
end
