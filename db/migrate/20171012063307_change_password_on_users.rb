class ChangePasswordOnUsers < ActiveRecord::Migration[5.1]
  def change
  	change_table :users do |t|
      t.rename :password_digest, :password
    end
  end
end
