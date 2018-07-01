class AddDecategoryToDevices < ActiveRecord::Migration[5.1]
  def change
    add_column :devices, :category_id, :integer
  end
end
