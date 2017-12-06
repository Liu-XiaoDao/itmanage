class AddPositionToUsers < ActiveRecord::Migration[5.1]
  def change
  	add_column :users, :position, :string    #员工职位
  end
end
