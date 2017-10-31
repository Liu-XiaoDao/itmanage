class Decategory < ApplicationRecord

	validates :name,  uniqueness: { case_sensitive: false },
                      length: { minimum: 2 },
                      presence: true

	has_many :devices

end
