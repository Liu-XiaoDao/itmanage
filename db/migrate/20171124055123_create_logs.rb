class CreateLogs < ActiveRecord::Migration[5.1]
  def change
    create_table :logs do |t|
      t.string   'ip',           default: false
      t.string   'controller'
      t.string   'action'
      t.string   'params'
      t.boolean  'success',           default: false
      t.timestamps
    end
  end
end
