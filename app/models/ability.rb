# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    # Initialize local user variable if no user detected.
    user ||= User.new

    # Open access to everything for admin users.
    if user.admin_role?
      can :manage, :all
      can :access, :rails_admin
    end

    # Set limitations on actions a user can perform.
    if user.present?
      can %i[edit update destroy], Stall, user_id: user.id
      can %i[create edit update destroy], Product, stall_id: user.stall&.id
      can %i[create destroy], Favourite, user_id: user.id
    end
  end
end
