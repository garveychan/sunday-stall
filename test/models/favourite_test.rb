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
require "test_helper"

class FavouriteTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
