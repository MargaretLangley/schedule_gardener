module Abilities
  class Admin
    include CanCan::Ability

    def initialize(user)
      can :manage, :all
      cannot :destroy, user, id: user.id
    end
  end
end
