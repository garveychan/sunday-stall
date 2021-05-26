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
        can [:edit, :update, :destroy], Stall, user_id: user.id
        can [:edit, :update, :destroy], Product, stall_id: user.stall.id
        can [:create, :destroy], Favourite, user_id: user.id
      end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  end
end
