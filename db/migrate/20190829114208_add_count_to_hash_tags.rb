class AddCountToHashTags < ActiveRecord::Migration[6.0]
  def change
    add_column :hash_tags, :count, :integer, default: 0
  end
end
