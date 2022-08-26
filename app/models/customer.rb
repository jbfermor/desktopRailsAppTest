class Customer < ApplicationRecord

  has_many :retailers, dependent: :destroy
  has_many :reports, dependent: :destroy

end
