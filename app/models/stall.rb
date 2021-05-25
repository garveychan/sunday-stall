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
  belongs_to :user # Stall belongs to one user.
  has_one_attached :image # Blobs automatically purged if stall is destroyed.
  has_many :favourites, as: :favouriteable, dependent: :destroy # Destroy any favourite associations with users.
  has_many :products, dependent: :destroy # Destroy products associated with stall as well.
  has_and_belongs_to_many :keywords # Stall may have many keywords assigned to it. On delete, the keywords will remain but the join table records will be destroyed.
  accepts_nested_attributes_for :keywords, reject_if: lambda {|attributes| attributes['term'].blank?} # Accepts keywords via Stall-based forms for persisting.

  # Validations
  validates :active, presence: true
  validates :user_id, presence: true
  validates :title, presence: true, length: { maximum: 50 }
  validates :subtitle, presence: true, length: { maximum: 100 }
  validates :description, presence: true, length: { maximum: 2000 }
  validates :keywords, presence: true
  validates :image, attached: true, size: { less_than: 10.megabytes, message: 'larger than 10MB!' }

  # Delegations
  # By the Law of Demeter, models should only talk to their immediate associations.
  # This reduces dependencies, enabling code reuse and easier maintainability.
  # e.g. View will call stall.user_email instead of stall.user.email
  delegate :email, to: :user, prefix: true
end
