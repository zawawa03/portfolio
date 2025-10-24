class CreateRooms < ActiveRecord::Migration[7.2]
  def change
    create_table :rooms do |t|
      t.timestamps

      t.references :creator, foreign_key: { to_table: :users }, null: false
      t.string :title, null: false
      t.string :body
      t.integer :people, null: false
    end
  end
end
