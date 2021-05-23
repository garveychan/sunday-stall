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
  enum role: { admin: 'admin', moderator: 'moderator', user: 'user'}, _suffix: true

  # Associations
  has_one :address, dependent: :destroy
  has_one :stall, dependent: :destroy

  has_many :reviews
  has_many :products, through: :reviews

  after_create :set_default_role, :welcome_email

  private

  def welcome_email
    UserMailer.send_welcome_email(self).deliver_later
  end

  def set_default_role
    self.role ||= User.roles[:user]
    self.save
  end
end
