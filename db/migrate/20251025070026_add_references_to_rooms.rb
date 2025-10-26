class AddReferencesToRooms < ActiveRecord::Migration[7.2]
  def change
    add_reference :rooms, :game, null: false, foreign_key: true
  end
end
