class CreateProcessResources < ActiveRecord::Migration[5.1]
  def change
    create_table :process_resources do |t|
      t.references :entry_process
      t.string :resource_name
      t.integer  :default
      t.integer  :enable
      t.timestamps
    end
  end
end
