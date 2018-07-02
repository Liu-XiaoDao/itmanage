class CreateAuthorizationservices < ActiveRecord::Migration[5.1]
  def change
    create_table :authorizationservices do |t|
      t.string       'servicename',            null: false      #服务名称
      t.references   'authorization',                 foreign_key: true   #需要维保的设备
      t.string       'serviceprovider'              #设备提供者
      t.float        'price'                        #服务价格
      t.datetime    'begin_date'                  #服务开始时间
      t.integer     'months'                      #服务月数
      t.datetime    'end_date'
      t.datetime    'authorizationscraptime'              #服务到期时间
      t.string      'describe'
      t.timestamps
    end
  end
end
