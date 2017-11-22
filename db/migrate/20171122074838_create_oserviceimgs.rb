class CreateOserviceimgs < ActiveRecord::Migration[5.1] #其他服务图片(应该是存放合同或者发票图片)
  def change
    create_table :oserviceimgs do |t|
      t.string   	'imgurl',                 null: false		  #其他服务图片路径
      t.references 	'otherservice',           foreign_key: true   #其他服务
      t.timestamps
    end
  end
end
