class Review < ApplicationRecord
  belongs_to :user
  belongs_to :product

  validates :rating, inclusion: { in: 1..5 }
  validates :rating, numericality: { only_integer: true }
end
