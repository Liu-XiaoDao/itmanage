class AddPartcategoryFromParts < ActiveRecord::Migration[5.1]
  def change
	add_foreign_key :parts, :partcategories
  end
end
