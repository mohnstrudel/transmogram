class AddIndexesToPosts < ActiveRecord::Migration[5.2]
  def change
    add_reference :posts, :armor_type, foreign_key: true
    add_reference :posts, :class_type, foreign_key: true
  end
end
