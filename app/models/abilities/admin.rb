module Abilities
  #
  # Authenticated
  #  - admin users have full management abilities - except destroying themselves
  #  - part of CanCanCan abilities authorization - see ability.rb
  #
  class Admin
    include CanCan::Ability

    def initialize(user)
      can :manage, :all
      cannot :destroy, user, id: user.id
    end
  end
end
