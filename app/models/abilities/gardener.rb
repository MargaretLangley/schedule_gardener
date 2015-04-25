module Abilities
  #
  # Gardener
  #  - authorization for gardeners
  #    - gardeners are the power users of the application
  #  - part of CanCanCan abilities authorization - see ability.rb
  #
  class Gardener
    include CanCan::Ability

    def initialize(*)
      can :manage, [Appointment, Touch]
      can [:read, :create, :update], User
    end
  end
end
