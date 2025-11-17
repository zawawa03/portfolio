class Permit < ApplicationRecord
  after_create_commit { PermitBroadcastJob.perform_later self }

  belongs_to :user
  belongs_to :room

  validates :user_id, uniqueness: { scope: :room_id }
end
