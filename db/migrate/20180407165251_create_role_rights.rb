class CreateRoleRights < ActiveRecord::Migration[5.1]
  def change
    create_table :role_rights do |t|
      t.references 	'role'
      t.references 	'right'
      t.timestamps
    end
  end
end
