module Abilities
  class Authenticated
    include CanCan::Ability

    def initialize(user)
      can [:show, :create, :update], User, id: user.id
      can [:manage], [Appointment, Touch], contact_id: user.contact.id
    end
  end
end
