class ChangeDepartOnParts < ActiveRecord::Migration[5.1]
  def change
  	change_table :parts do |t|
  	  t.rename :decategory_id, :partcategory_id
  	end
  end
end
