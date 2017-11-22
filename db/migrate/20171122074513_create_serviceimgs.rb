class CreateServiceimgs < ActiveRecord::Migration[5.1]   #设备服务图片
  def change
    create_table :serviceimgs do |t|
      t.string   	'imgurl',                 null: false		  #服务图片路径
      t.references 	'deviceservice',          foreign_key: true   #服务(外键)
      t.timestamps
    end
  end
end
