class RemoveImageDataFromPosts < ActiveRecord::Migration[5.2]
  def change
    remove_column :posts, :image_data
  end
end
