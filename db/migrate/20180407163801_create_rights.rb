class CreateRights < ActiveRecord::Migration[5.1]
  def change
    create_table :rights do |t|
      t.string   :right_name
      t.string   :right, comment: '权限码(控制器@动作)'
      t.integer  :status
      t.timestamps
    end
  end
end
