class ChangeStatusStatusOnDevices < ActiveRecord::Migration[5.1]
  def change
    change_column_default(:devices, :status, 1)
  end
end
