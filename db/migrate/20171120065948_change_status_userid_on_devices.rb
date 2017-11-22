class ChangeStatusUseridOnDevices < ActiveRecord::Migration[5.1]
  def change
  	change_column_default(:devices, :user_id, 0)
  end
end
