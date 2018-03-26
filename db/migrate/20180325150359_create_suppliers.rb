class CreateSuppliers < ActiveRecord::Migration[5.1]
  def change
    create_table :suppliers do |t|
      t.string      'product_name'
      t.string      'supplier_name'
      t.string      'contact'
      t.string      'contact_information'
      t.string      'note'            #备注
      t.timestamps
    end
  end
end
