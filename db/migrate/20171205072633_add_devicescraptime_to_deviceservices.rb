class AddDevicescraptimeToDeviceservices < ActiveRecord::Migration[5.1]
  def change
    add_column :deviceservices, :devicescraptime, :datetime   #设备服务中添加字段保存,设备之前的服务到期时间,然后再把设备的服务到期时间改为添加的这个服务的时间
  end
end
