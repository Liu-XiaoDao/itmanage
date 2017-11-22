class AddDecategorycodeToDecategories < ActiveRecord::Migration[5.1]
  def change
  	add_column :decategories, :decategorycode, :string
  end
end
