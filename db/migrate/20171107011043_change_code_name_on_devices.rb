class ChangeCodeNameOnDevices < ActiveRecord::Migration[5.1]
  def change
  	change_column_null(:devices, :asset_code, true)
  	change_column_null(:devices, :asset_name, true)
  end
end
