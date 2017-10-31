class Device < ApplicationRecord


	validates :asset_code, presence: true   #这几个变量不能为空
  	validates :asset_code,  :service_sn,  :asset_details,   length: { in: 6..25 } #长度6-25
                       																					

end


# uniqueness: { case_sensitive: false }  #唯一性检测，不区分大小写