class ChangeBelongtoOnDevices < ActiveRecord::Migration[5.1]
  def change
    change_column(:devices, :belong_to, :integer)
  end
end
