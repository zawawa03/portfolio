class CreateComments < ActiveRecord::Migration[7.2]
  def change
    create_table :comments do |t|
      t.timestamps
      
      t.references :board, foreign_key: true, null: false
      t.references :user, foreign_key: true, null: true
      t.string :body, null: false
      t.references :parent, foreign_key: { to_table: :comments }, null: true
    end
  end
end
