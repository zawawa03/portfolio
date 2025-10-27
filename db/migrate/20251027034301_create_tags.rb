class CreateTags < ActiveRecord::Migration[7.2]
  def change
    create_table :tags do |t|
      t.timestamps

      t.string :name, null: false
      t.integer :category, null: false
    end
    add_index :tags, [ "name", "category" ], unique: true, name: "index_tags_on_name_and_category"
  end
end
