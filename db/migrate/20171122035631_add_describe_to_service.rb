class AddDescribeToService < ActiveRecord::Migration[5.1]
  def change
  	add_column :deviceservices, :describe, :string   #设备服务表添加描述字段
  	add_column :otherservices, :describe, :string    #其他服务添加描述字段
  end
end
