class CreateDepartments < ActiveRecord::Migration[5.1]
  def change
    create_table :departments do |t|
      t.string   'department_name',             null: false     
      t.string  'manager_name'
      t.timestamps
    end
  end
end
