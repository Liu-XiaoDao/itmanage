class AddIsquitToUsers < ActiveRecord::Migration[5.1]
  def change
  	add_column :users, :is_quit, :integer, default: 0
  end
end
