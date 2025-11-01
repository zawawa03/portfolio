class CreateFriends < ActiveRecord::Migration[7.2]
  def change
    create_table :friends do |t|
      t.timestamps

      t.references :leader, foreign_key: { to_table: :users }, null: false
      t.references :follower, foreign_key: { to_table: :users }, null: false
      t.integer :category, null: false, default: 0
    end
    add_index :friends, [ :leader_id, :follower_id ], unique: true
    add_index :friends, [ :follower_id, :leader_id ], unique: true
  end
end
