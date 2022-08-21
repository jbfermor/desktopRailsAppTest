class Printer < ApplicationRecord
  belongs_to :report
  validates_uniqueness_of :name, on: :create

end
