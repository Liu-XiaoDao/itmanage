class Device < ApplicationRecord
	belongs_to :user, optional: true
	has_many :cdevices, class_name: 'Device', foreign_key: 'belong_to'
	belongs_to :mdevice, class_name:  'Device', foreign_key: 'belong_to', optional: true

	
	# validates :asset_code,  :asset_name,  :service_sn, :decategory_id, :release_date, :asset_details,  presence: true   #这几个变量不能为空
	# validates :asset_code,  :asset_name,  :service_sn,  :asset_details,   length: { in: 6..25 } #长度6-25
	validates :asset_name,  :decategory_id, :release_date,  presence: true
  	validates :asset_name,  length: { in: 6..25 } #长度6-25


end


# uniqueness: { case_sensitive: false }  #唯一性检测，不区分大小写
