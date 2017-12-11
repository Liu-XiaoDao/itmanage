class Consumable < ApplicationRecord
  has_many :consumablerecords
  has_many :users, through: :consumablerecords

  validates :name, :unit, :surplus_amount, :location, presence: true  
  validates :name, length: { in: 1..20 }

end
