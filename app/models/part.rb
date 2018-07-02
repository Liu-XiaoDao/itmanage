class Part < ApplicationRecord
  belongs_to :device, optional: true   #设备会分配给用户使用(借用,办公分配)

end
