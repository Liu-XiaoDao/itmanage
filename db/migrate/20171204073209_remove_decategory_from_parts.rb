class RemoveDecategoryFromParts < ActiveRecord::Migration[5.1]
  def change
    remove_foreign_key :parts, :decategories
    # remove_column(:parts, :partcategory_id)
    # remove_column(:parts, :decategory)
  # remove_reference(:devices, :belong_to)
  # remove_foreign_key :accounts, :branches
    # 在上面创建的时候(create_parts),把对partcategory的外键,创建到decategory上了,.....,重点:但是rails执行migrate时,自动把列名改成了.partcategory_id,但是依赖在decategory上,所以也是很神奇的
    # 然后我要删除这个外键,试了好几种,都不行,最后的这个才行(remove_foreign_key :parts, :decategories)还不知道原因,以后再找吧
  end
end
