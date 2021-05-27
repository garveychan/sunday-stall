# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  date_of_birth          :date
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  first_name             :string(50)
#  last_name              :string(50)
#  phone_number           :string(12)
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  role                   :enum
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_role                  (role)
#
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  # User Role Enum
  # user.admin_role? user.moderator_role? user.user_role?
  enum role: { admin: 'admin', moderator: 'moderator', user: 'user'}, _suffix: true, _default: :user

  # Associations
  has_one :stall, dependent: :destroy
  has_many :favourites, dependent: :destroy

  # Validations
  validates :email, presence: true
  validates :encrypted_password, presence: true
  validates :first_name, length: { maximum: 50 }
  validates :last_name, length: { maximum: 50 }
  validates :phone_number, length: { maximum: 12 }

  # Delegations
  delegate :id, to: :stall, prefix: true # User.stall_id
end