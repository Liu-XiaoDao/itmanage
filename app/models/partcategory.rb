class Partcategory < ApplicationRecord

  has_many :parts

  has_many :cpartcategory, class_name: 'Partcategory', foreign_key: 'parent_id'
  belongs_to :mpartcategory, class_name:  'Partcategory', foreign_key: 'parent_id', optional: true



  validates :name,  uniqueness: { case_sensitive: false },
                  length: { minimum: 2 },
                  presence: true
  validates :partcategorycode,  uniqueness: { case_sensitive: false },
                  			length: { in: 2..10 },
                  			presence: true


  def self.alltree
    @partcategoryss = Partcategory.all
    @partcategorys = []
    GetTree(@partcategoryss,0,0,@partcategorys,'----')
    return @partcategorys
  end

  #部门分类缩进
  def self.GetTree(arr,pid,step,newarr,indentstr)
    for item in arr
      if item['parent_id'] == pid
        indent = indentstr * step
        item['name'] = indent + item['name']
        newarr.push item
        GetTree(arr , item['id'] ,step+1,newarr,indentstr)
      end
    end
  end

  def self.leafpartcategory
    havelowerpartcategorys = Partcategory.joins("INNER JOIN partcategorys as b ON partcategorys.id = b.parent_id ").select('id').distinct
    partcategorys = Partcategory.where.not(id: havelowerpartcategorys.collect{|partcategory| partcategory.id }).order('pgcode')
  end


end
