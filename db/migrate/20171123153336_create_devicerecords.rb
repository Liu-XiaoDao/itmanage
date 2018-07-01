class CreateDevicerecords < ActiveRecord::Migration[5.1]
  def change
    create_table :devicerecords do |t|
    t.references   'user',                 foreign_key: true   #
    t.references   'device',               foreign_key: true   #需要维保的设备
    t.string      'note'                  #备注
      t.timestamps
      t.timestamps
    end
  end
end
