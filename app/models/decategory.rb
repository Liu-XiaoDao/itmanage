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

end
