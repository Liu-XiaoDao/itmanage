class AddDepartmentToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :department, :text
  end
end
