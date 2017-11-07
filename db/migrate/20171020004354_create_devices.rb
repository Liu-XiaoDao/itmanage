class CreateDevices < ActiveRecord::Migration[5.1]
  def change
    create_table :devices do |t|
      t.string   	'asset_code',            null: false     	#设备号
      t.string   	'asset_name',            null: false	    #设备名称
      t.string   	'service_sn'								#设备服务号
      t.string   	'model'										#设备类型
      t.string   	'managed_by'							    #设备管理部门
      t.string   	'asset_details'								#设备详情
      t.string   	'belong_to'									#设备所属,比如:内存条属于电脑
      t.integer  	'status'									#设备状态:0未分配,1办公用,2闲置,3维修,4借用,5报废,6报废借用,7报废清理
      t.datetime  	'receive_date'								#到货时间
      t.datetime	'first_date'								#第一次使用时间
      t.datetime	'scrap_date'								#销毁时间
      t.timestamps
    end
  end
end
