# == Schema Information
#
# Table name: addresses
#
#  id           :bigint           not null, primary key
#  city_name    :string(50)
#  country_name :string(50)
#  post_code    :integer
#  state_name   :string(50)
#  street_name  :string(50)
#  street_num   :integer
#  unit_num     :integer
#  user_id      :bigint           not null
#
# Indexes
#
#  index_addresses_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Address < ApplicationRecord
  belongs_to :user
end
