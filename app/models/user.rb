# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  date_of_birth          :date             not null
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  first_name             :string(50)       not null
#  last_name              :string(50)       not null
#  phone_number           :string(12)       not null
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
  validates :first_name, presence: true, length: { maximum: 50 }
  validates :last_name, presence: true, length: { maximum: 50 }
  validates :phone_number, presence: true, length: { maximum: 12 }
  validates :date_of_birth, presence: true
  validate :date_of_birth_cannot_be_after_today

  # Delegations
  delegate :id, to: :stall, prefix: true, allow_nil: true # User.stall_ido

  private

  def date_of_birth_cannot_be_after_today
    if date_of_birth.present? && date_of_birth > Date.today
      errors.add(:date_of_birth, " can't be in the future")
    end
  end
end
