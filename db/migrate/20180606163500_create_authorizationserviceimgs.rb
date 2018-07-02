class CreateAuthorizationserviceimgs < ActiveRecord::Migration[5.1]
  def change
    create_table :authorizationserviceimgs do |t|
      t.string       'imgurl',                 null: false      #服务图片路径
      t.references   'authorizationservice',          foreign_key: true   #服务(外键)
      t.string       'original'
      t.timestamps
    end
  end
end
