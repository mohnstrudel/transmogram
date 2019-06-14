class CreateImages < ActiveRecord::Migration[5.2]
  def change
    create_table :images do |t|
      t.string :image_value
      t.belongs_to :post, foreign_key: true

      t.timestamps
    end
  end
end
