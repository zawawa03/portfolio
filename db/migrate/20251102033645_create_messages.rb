class CreateMessages < ActiveRecord::Migration[7.2]
  def change
    create_table :messages do |t|
      t.timestamps

      t.references :user, foreign_key: true, null: false
      t.references :room, foreign_key: true, null: false
      t.string :body, null: false
    end
  end
end
