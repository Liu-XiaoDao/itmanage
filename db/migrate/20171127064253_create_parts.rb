class CreateParts < ActiveRecord::Migration[5.1]
  def change
    create_table :parts do |t|
      t.string   	'part_code',            null: false     	#配件号
      t.string   	'part_name',            null: false	        #配件名称
      t.string   	'part_details'								#配件详情
      t.integer  	'status'									#配件状态:1.未使用,2.正在使用,3.闲置
      t.datetime  	'receive_date'								#到货时间
      t.datetime	'assign_time'								#分配时间
      t.references  'device', foreign_key: true                 #所属设备
      t.references  'decategory', foreign_key: true             #配件分类
      t.integer  	'is_assign'									#配件是否分配,   0未分配,1已分配
      t.timestamps
    end
  end
end
