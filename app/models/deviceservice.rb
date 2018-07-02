class Deviceservice < ApplicationRecord
  belongs_to :device, optional: true    #一条服务记录属于一个设备

  has_many :attached_files, ->{ where( attached_files: { target_class: "deviceservices" } ) }, :foreign_key => :target_id #一个服务会有多个附件
end
