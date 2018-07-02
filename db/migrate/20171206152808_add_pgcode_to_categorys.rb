class AddPgcodeToCategorys < ActiveRecord::Migration[5.1]
  def change
    add_column :decategories, :pgcode, :string
    add_column :partcategories, :pgcode, :string
  end
end
