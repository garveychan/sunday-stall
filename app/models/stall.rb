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
  belongs_to :user
  has_many :products, dependent: :destroy
  has_and_belongs_to_many :keywords, dependent: :destroy
  has_many_attached :images # blobs automatically purged if stall is deleted
  has_many :favourites, as: :favouriteable
end
