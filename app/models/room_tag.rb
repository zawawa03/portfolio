class RoomTag < ApplicationRecord
  belongs_to :tag
  belongs_to :room
end
