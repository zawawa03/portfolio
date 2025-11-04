class AddCategoryToRooms < ActiveRecord::Migration[7.2]
  def change
    add_column :rooms, :category, :integer, null: false, default: 0
  end
end
