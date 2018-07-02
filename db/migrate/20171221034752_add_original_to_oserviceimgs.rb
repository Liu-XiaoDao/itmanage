class AddOriginalToOserviceimgs < ActiveRecord::Migration[5.1]
  def change
    add_column :oserviceimgs, :original, :string
  end
end
