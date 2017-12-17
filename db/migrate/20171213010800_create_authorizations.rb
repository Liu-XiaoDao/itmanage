class CreateAuthorizations < ActiveRecord::Migration[5.1]
  def change
    create_table :authorizations do |t|
	  t.string      'name'                 #授权名称
	  t.string      'serial_number'        #授权序列号
	  t.string      'key'                  #激活码
	  t.datetime    'begin_date'           #授权开始时间
	  t.datetime    'end_date'             #授权结束时间
	  t.integer     'available_quantity'   #可用数量
	  t.integer     'amount'               #总数
	  t.float       'price'                #单价
	  t.string      'contact_information'  #联系方式
	  t.string      'manufacturer'         #厂商
      t.timestamps
    end
  end
end
