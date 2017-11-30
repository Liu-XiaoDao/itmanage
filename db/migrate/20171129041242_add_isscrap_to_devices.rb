class AddIsscrapToDevices < ActiveRecord::Migration[5.1]
  def change
  	add_column :devices, :is_scrap, :integer, default: 0    #其他服务添加描述字段
  end
end
