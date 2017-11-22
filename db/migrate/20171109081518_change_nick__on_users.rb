class ChangeNickOnUsers < ActiveRecord::Migration[5.1]
  def change
  	change_table :users do |t|
      t.rename :nickname, :attendance
    end
  end
end
