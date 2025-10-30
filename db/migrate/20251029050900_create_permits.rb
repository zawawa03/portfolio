class CreatePermits < ActiveRecord::Migration[7.2]
  def change
    create_table :permits do |t|
      t.timestamps

      t.references :user, foreign_key: true, null: false
      t.references :room, foreign_key: true, null: false
    end
    add_index :permits, [ :user_id, :room_id ], unique: true
  end
end
