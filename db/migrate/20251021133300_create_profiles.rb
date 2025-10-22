class CreateProfiles < ActiveRecord::Migration[7.2]
  def change
    create_table :profiles do |t|
      t.timestamps
      t.references :user, foreign_key: true, null: false
      t.string :nickname, null: false
      t.integer :sex, default: 0, null: false
      t.string :introduction
    end
    add_index :profiles, :nickname, unique: true
  end
end
