class CreateBoards < ActiveRecord::Migration[7.2]
  def change
    create_table :boards do |t|
      t.timestamps

      t.references :creator, foreign_key: { to_table: :users }, null: false
      t.references :game, foreign_key: true, null: false
      t.string :title, null: false
    end
  end
end
