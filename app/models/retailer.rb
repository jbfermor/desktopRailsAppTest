class Retailer < ApplicationRecord
  belongs_to :customer
  has_many :shops
end
