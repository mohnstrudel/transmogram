class AddFieldsToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :nickname, :string
    add_column :users, :firstname, :string
    add_column :users, :bio, :string
  end
end
