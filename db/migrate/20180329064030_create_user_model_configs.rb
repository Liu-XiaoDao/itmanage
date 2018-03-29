class CreateUserModelConfigs < ActiveRecord::Migration[5.1]
  def change
    create_table :user_model_configs do |t|
      t.references :user
      t.string :model
      t.text :fields_text
      t.timestamps
    end
  end
end
