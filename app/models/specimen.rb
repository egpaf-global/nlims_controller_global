class Specimen < ApplicationRecord
  self.table_name = 'specimen'
  validates :tracking_number, presence: {message: 'Tracking Number cannont be blank'}
  validates :tracking_number, uniqueness: true
  has_many :tests
end
