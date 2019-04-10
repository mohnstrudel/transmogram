class CreateClassTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :class_types do |t|
      t.string :value

      t.timestamps
    end
  end
end
