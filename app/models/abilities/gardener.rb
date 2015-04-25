module Abilities
  class Gardener
    include CanCan::Ability

    def initialize(*)
      can :manage, [Appointment, Touch]
      can [:read, :create, :update], User
    end
  end
end
