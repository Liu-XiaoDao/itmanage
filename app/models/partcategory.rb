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

end
