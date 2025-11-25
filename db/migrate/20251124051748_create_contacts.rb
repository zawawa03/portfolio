class CreateContacts < ActiveRecord::Migration[7.2]
  def change
    create_table :contacts do |t|
      t.timestamps

      t.references :user, foreign_key: true, null: false
      t.string :email, null: false
      t.string :name, null: false
      t.string :body, null: false
    end
  end
end
