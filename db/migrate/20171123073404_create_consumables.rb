class CreateConsumables < ActiveRecord::Migration[5.1]
  def change
    create_table :consumables do |t|
      t.string   	'name',                 null: false     	#耗材名
      t.string   	'unit'                                  	#单位
      t.integer  	'amount'									#总数量
      t.integer  	'used_amount'								#已用数量
      t.integer  	'surplus_amount'							#可用数量
      t.string   	'location'                                 	#存放位置
      t.timestamps
    end
  end
end
