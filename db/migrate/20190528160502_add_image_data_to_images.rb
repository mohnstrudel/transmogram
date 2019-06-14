class AddImageDataToImages < ActiveRecord::Migration[5.2]
  def change
    add_column :images, :image_value_data, :text
  end
end
