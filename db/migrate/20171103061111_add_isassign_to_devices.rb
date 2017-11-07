class AddIsassignToDevices < ActiveRecord::Migration[5.1]
  def change
  	add_column :devices, :is_assign, :integer
  end
end
