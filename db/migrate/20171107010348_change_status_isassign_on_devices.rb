class ChangeStatusIsassignOnDevices < ActiveRecord::Migration[5.1]
  def change
    change_column_default(:devices, :status, 0)
    change_column_default(:devices, :is_assign, 0)
  end
end
