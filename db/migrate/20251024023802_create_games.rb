class CreateGames < ActiveRecord::Migration[7.2]
  def change
    create_table :games do |t|
      t.timestamps

      t.string :name, null: false
    end
  end
end
