class CreatePartrecords < ActiveRecord::Migration[5.1]
  def change
    create_table :partrecords do |t|
      t.references   'part',                 foreign_key: true   #
      t.references   'device',               foreign_key: true   #需要维保的设备
      t.string       'note'                  #备注
      t.timestamps
    end
  end
end
