class Patient < ApplicationRecord
  validates :patient_number, uniqueness: true
end
