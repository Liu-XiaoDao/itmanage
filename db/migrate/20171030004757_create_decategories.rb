class CreateDecategories < ActiveRecord::Migration[5.1]
  def change
    create_table :decategories do |t|
      t.string :name
        t.timestamps
    end
  end
end
