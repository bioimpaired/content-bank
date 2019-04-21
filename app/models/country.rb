class Country < ApplicationRecord
  validates :name, presence: true

  has_many :ads
end
