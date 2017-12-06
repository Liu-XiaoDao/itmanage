class AddParentIdToDepartments < ActiveRecord::Migration[5.1]
  def change
  	add_column :departments, :parent_id, :integer, default: 0
  	add_column :departments, :pgcode, :string
  end
end
