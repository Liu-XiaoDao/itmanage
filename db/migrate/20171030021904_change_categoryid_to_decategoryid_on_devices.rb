class ChangeCategoryidToDecategoryidOnDevices < ActiveRecord::Migration[5.1]
  def change
  	change_table :devices do |t|
      t.rename :category_id, :decategory_id
    end
  end
end
