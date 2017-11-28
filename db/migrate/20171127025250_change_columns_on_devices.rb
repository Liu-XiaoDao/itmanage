class ChangeColumnsOnDevices < ActiveRecord::Migration[5.1]
  def change
  	add_column :devices, :location, :string
  	remove_column :devices, :model
  	remove_column :devices, :managed_by
  end
end
