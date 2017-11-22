class Deviceservice < ApplicationRecord
	belongs_to :device, optional: true    #一条服务记录属于一个设备

	has_many :serviceimgs   #一个服务会有多张图片
end
