# == Schema Information
#
# Table name: stalls
#
#  id          :bigint           not null, primary key
#  active      :boolean          not null
#  description :text             not null
#  subtitle    :string(100)      not null
#  title       :string(50)       not null
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
require "test_helper"

class StallTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
