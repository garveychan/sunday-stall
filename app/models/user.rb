# == Schema Information
#
# Table name: users
#
#  id            :bigint           not null, primary key
#  date_of_birth :date
#  email_address :string(100)      not null
#  first_name    :string(50)
#  last_name     :string(50)
#  phone_number  :string(12)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
class User < ApplicationRecord
  has_one :address, dependent: :destroy
  has_one :stall, dependent: :destroy

  validates :email_address,
    uniqueness: {
      message: ->(_, data) { "It looks like #{data[:value]} is already in use. Perhaps you'd like to login?" }
    }
end
