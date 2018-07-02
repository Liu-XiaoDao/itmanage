class ChangeStatusUserid2OnDevices < ActiveRecord::Migration[5.1]
  def change
    change_column_default(:devices, :user_id, nil)
  end
end
