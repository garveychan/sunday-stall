# == Schema Information
#
# Table name: products
#
#  id                  :bigint           not null, primary key
#  active              :boolean          not null
#  description         :text             not null
#  name                :string(50)       not null
#  stock_level         :integer          not null
#  unit_price          :decimal(8, 2)    not null
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
  # Associations
  belongs_to :stall, inverse_of: :products
  belongs_to :product_category
  has_many :reviews
  has_many :users, through: :reviews
  has_one_attached :image # blobs automatically purged if product deleted
  has_many :favourites, as: :favouriteable, dependent: :destroy

  # Validations
  validates :active, presence: true
  validates :description, presence: true, length: { maximum: 1000 }
  validates :name, presence: true, length: { maximum: 50 }
  validates :stock_level, presence: true
  validates :unit_price, presence: true
  validates :product_category_id, presence: true
  validates :stall_id, presence: true
  validates :image, attached: true, size: { less_than: 10.megabytes, message: 'larger than 10MB!' }

  # Scope Extensions
  scope :favourites, lambda { |user|
    joins(:favourites)
      .where(favourites: { user_id: user.id })
  }

  # Delegations
  delegate :id, to: :stall, prefix: true # Product.stall_id
  delegate :title, to: :stall, prefix: true # Product.stall_title
  delegate :user_email, to: :stall, prefix: true # Product.stall_user_email
end
