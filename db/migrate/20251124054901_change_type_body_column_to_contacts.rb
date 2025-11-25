class ChangeTypeBodyColumnToContacts < ActiveRecord::Migration[7.2]
  def change
    change_column :contacts, :body, :text
  end
end
