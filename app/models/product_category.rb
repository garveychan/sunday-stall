# == Schema Information
#
# Table name: product_categories
#
#  id   :bigint           not null, primary key
#  name :string(50)       not null
#
class ProductCategory < ApplicationRecord
  has_many :products
end
