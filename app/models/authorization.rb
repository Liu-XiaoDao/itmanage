class Authorization < ApplicationRecord
	validates :name,  :serial_number, :key, :begin_date, :end_date, :amount, :price, :manufacturer, :contact_information,  presence: true  #这几个不能为空

	#授权分配记录
	has_many :authorization_user_devices
	has_many :users, through: :authorization_user_devices
	has_many :devices, through: :authorization_user_devices
end
