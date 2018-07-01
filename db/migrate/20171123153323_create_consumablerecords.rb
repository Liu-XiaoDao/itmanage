class CreateConsumablerecords < ActiveRecord::Migration[5.1]
  def change
    create_table :consumablerecords do |t|
    t.references   'user',                 foreign_key: true   #
    t.references   'consumable',           foreign_key: true   #耗材的种类
    # t.integer     'number'                #数量       一次领一个,不会大量领取
    t.string      'note'                  #备注
      t.timestamps
    end
  end
end
