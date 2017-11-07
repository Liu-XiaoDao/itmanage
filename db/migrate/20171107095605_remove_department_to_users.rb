class RemoveDepartmentToUsers < ActiveRecord::Migration[5.1]
  def change
  	remove_column(:users, :department)
  end
end
