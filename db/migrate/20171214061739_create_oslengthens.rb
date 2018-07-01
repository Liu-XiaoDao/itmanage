class CreateOslengthens < ActiveRecord::Migration[5.1]
  def change
    create_table :oslengthens do |t|
      t.references  'otherservice'    #延长时间的服务
      t.datetime    'serviceenddate'  #服务之前的到期时间
      t.datetime    'bagindate'       #延长服务的开始时间
      t.datetime    'enddate'         #延长服务的结束时间
      t.string      'note'            #备注
      t.float       'price'           #延长服务的价格
      t.timestamps
    end
  end
end
