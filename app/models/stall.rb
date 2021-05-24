# == Schema Information
#
# Table name: stalls
#
#  id          :bigint           not null, primary key
#  active      :boolean          not null
#  description :text
#  subtitle    :string(100)
#  title       :string(50)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :bigint           not null
#
# Indexes
#
#  index_stalls_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Stall < ApplicationRecord
  # Associations
  belongs_to :user
  has_one_attached :image # blobs automatically purged if stall is deleted
  has_many :favourites, as: :favouriteable
  has_many :products, dependent: :destroy
  has_and_belongs_to_many :keywords
  accepts_nested_attributes_for :keywords, reject_if: lambda {|attributes| attributes['term'].blank?}

  # Validations
  validates :active, presence: true
  validates :user_id, presence: true
  validates :title, presence: true, length: { maximum: 50 }
  validates :subtitle, presence: true, length: { maximum: 100 }
  validates :description, presence: true, length: { maximum: 2000 }
  validates_associated :keywords
  validates :image, attached: true, size: { less_than: 10.megabytes , message: 'larger than 10MB!' }
end
