class ChangeReceiveDateOnDevices < ActiveRecord::Migration[5.1]
  def change
  	change_table :devices do |t|
      t.rename :receive_date, :release_date
    end
  end
end
