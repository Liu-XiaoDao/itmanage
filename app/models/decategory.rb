class Decategory < ApplicationRecord

  has_many :devices  #分类下有多台设备

  has_many :cdecategory, class_name: 'Decategory', foreign_key: 'parent_id'   #一个分类有多个子类
  belongs_to :mdecategory, class_name:  'Decategory', foreign_key: 'parent_id', optional: true   #一个分类有一个父类


  #分类名不能为空,长度不能小于2,不能重复
  validates :name,  uniqueness: { case_sensitive: false },
                  length: { minimum: 2 },
                  presence: true
  #分类代码,不能为空,可以重复,长度2-10
  validates :decategorycode,  length: { in: 2..10 },
                  			  presence: true


  def self.alltree
    @decategoryss = Decategory.all
    @decategorys = []
    GetTree(@decategoryss,0,0,@decategorys,'----')
    return @decategorys
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

  def self.leafdecategory
    havelowerdecategorys = Decategory.joins("INNER JOIN decategories as b ON decategories.id = b.parent_id ").select('id').distinct
    decategorys = Decategory.where.not(id: havelowerdecategorys.collect{|decategory| decategory.id }).order('pgcode')
  end


end
