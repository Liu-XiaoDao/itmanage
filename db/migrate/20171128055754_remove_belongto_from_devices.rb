class RemoveBelongtoFromDevices < ActiveRecord::Migration[5.1]
  def change
    remove_column(:devices, :belong_to)
  end
end
