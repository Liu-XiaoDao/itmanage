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
      t.integer  	'status'									#设备状态:1未分配,2办公用,3闲置,4维修,5借用,6报废,7报废借用,8报废清理,9从属于别人
      t.datetime  	'receive_date'								#到货时间
      t.datetime	'first_date'								#第一次使用时间
      t.datetime	'scrap_date'								#销毁时间
      t.timestamps
    end
  end
end
