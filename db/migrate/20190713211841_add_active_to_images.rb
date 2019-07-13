class AddActiveToImages < ActiveRecord::Migration[5.2]
  def change
    add_column :images, :active, :boolean, :default => false
  end
end
