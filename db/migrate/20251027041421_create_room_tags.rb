class CreateRoomTags < ActiveRecord::Migration[7.2]
  def change
    create_table :room_tags do |t|
      t.timestamps

      t.references :room, foreign_key: true, null: false
      t.references :tag, foreign_key: true, null: false
    end
    add_index :room_tags, [ :room_id, :tag_id ], unique: true
  end
end
