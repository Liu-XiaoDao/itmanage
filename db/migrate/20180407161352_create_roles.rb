class CreateRoles < ActiveRecord::Migration[5.1]
  def change
    create_table :roles do |t|
      t.string  :role_name
      t.integer  :status
      t.timestamps
    end
  end
end
