class AddAssigntimeToDevices < ActiveRecord::Migration[5.1]
  def change
    add_column :devices, :assign_time, :datetime
  end
end
