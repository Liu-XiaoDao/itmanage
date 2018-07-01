class AddOriginalToServiceimgs < ActiveRecord::Migration[5.1]
  def change
    add_column :serviceimgs, :original, :string
  end
end
