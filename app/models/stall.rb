class Stall < ApplicationRecord
  belongs_to :user
  has_many :search_terms
  has_many_attached :images
end