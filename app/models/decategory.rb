class Decategory < ApplicationRecord

	has_many :devices

	has_many :cdecategory, class_name: 'Decategory', foreign_key: 'parent_id'
	belongs_to :mdecategory, class_name:  'Decategory', foreign_key: 'parent_id', optional: true



	validates :name,  uniqueness: { case_sensitive: false },
                      length: { minimum: 2 },
                      presence: true
    validates :decategorycode,  uniqueness: { case_sensitive: false },
                      			length: { in: 2..10 },
                      			presence: true

end
