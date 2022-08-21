class Customer < ApplicationRecord

  has_many :retailers
  has_many :reports

  path = ""


end
