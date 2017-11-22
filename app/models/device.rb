class Device < ApplicationRecord
	belongs_to :user, optional: true   #设备会分配给用户使用(借用,办公分配)

	has_many :cdevices, class_name: 'Device', foreign_key: 'belong_to'     #一个设备由多个从属设备,如内存.硬盘
	belongs_to :mdevice, class_name:  'Device', foreign_key: 'belong_to', optional: true    #有些设备会附加到其他设备,如内存条插到电脑上,那么电脑上就是主设备

	has_many :deviceservices #一个设备会有多条维保记录

	
	# validates :asset_code,  :asset_name,  :service_sn, :decategory_id, :release_date, :asset_details,  presence: true   #这几个变量不能为空
	# validates :asset_code,  :asset_name,  :service_sn,  :asset_details,   length: { in: 6..25 } #长度6-25
	validates :asset_name,  :decategory_id, :release_date,  presence: true
  	validates :asset_name,  length: { in: 6..25 } #长度6-25


end


# uniqueness: { case_sensitive: false }  #唯一性检测，不区分大小写
