# == Schema Information
#
# Table name: favourites
#
#  id                 :bigint           not null, primary key
#  favouriteable_type :string           not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  favouriteable_id   :bigint           not null
#  user_id            :bigint           not null
#
# Indexes
#
#  index_favourites_on_favouriteable  (favouriteable_type,favouriteable_id)
#  index_favourites_on_user_id        (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Favourite < ApplicationRecord
  # Associations
  belongs_to :user, foreign_key: :user_id
  belongs_to :favouriteable, polymorphic: true

# Extend scope for filtering by specific object and/or user if they exist
# Extend scope to filtering by type of Favourite - Stall or Product
  scope :for_user, -> (user) { where(user_id: user&.id) }
  scope :for_object, -> (object) { where(favouriteable_id: object&.id) }
  scope :stalls, -> { where(favouriteable_type: "Stall") }
  scope :products, -> { where(favouriteable_type: "Product") }
end
