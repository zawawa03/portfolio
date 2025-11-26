class CreateBoardTags < ActiveRecord::Migration[7.2]
  def change
    create_table :board_tags do |t|
      t.timestamps

      t.references :board, foreign_key: true, null: false
      t.references :tag, foreign_key: true, null: false
    end
    add_index :board_tags, [ :board_id, :tag_id ], unique: true
  end
end
