class CreatePartcategories < ActiveRecord::Migration[5.1]
  def change
    create_table :partcategories do |t|
      t.string :name
      t.string :partcategorycode
      t.integer :parent_id
      t.timestamps
    end
  end
end
