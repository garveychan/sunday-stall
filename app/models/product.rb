# == Schema Information
#
# Table name: products
#
#  id                  :bigint           not null, primary key
#  active              :boolean          not null
#  description         :text             not null
#  name                :string(5)        not null
#  price               :integer          not null
#  stock_level         :integer          not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  product_category_id :bigint           not null
#  stall_id            :bigint           not null
#
# Indexes
#
#  index_products_on_product_category_id  (product_category_id)
#  index_products_on_stall_id             (stall_id)
#
# Foreign Keys
#
#  fk_rails_...  (product_category_id => product_categories.id)
#  fk_rails_...  (stall_id => stalls.id)
#
class Product < ApplicationRecord
  belongs_to :stall
  belongs_to :product_category
  has_many_attached :images # blobs automatically purged if product deleted
end