class AddTimeleftToDevices < ActiveRecord::Migration[5.1]
  def change
    add_column :devices, :borrow_timeleft, :integer
  end
end
