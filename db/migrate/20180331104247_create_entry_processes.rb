class CreateEntryProcesses < ActiveRecord::Migration[5.1]
  def change
    create_table :entry_processes do |t|
      t.string :process_name
      t.integer  :display_order
      t.integer  :responsible
      t.integer  :enable
      t.timestamps
    end
  end
end
