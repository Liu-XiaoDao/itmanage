class CreateAttachedFiles < ActiveRecord::Migration[5.1]
  def change
    create_table :attached_files do |t|
      t.string    'filepath',                 null: false		  #其他服务图片路径
      t.string    'target_class'
      t.string    'target_id'
      t.string    'original'        #原始文件名
      t.timestamps
    end
  end
end
