class DropImgs < ActiveRecord::Migration[5.1]
  def change
    drop_table :authorizationserviceimgs
    drop_table :oserviceimgs
    drop_table :serviceimgs
  end
end
