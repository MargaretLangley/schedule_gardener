module Abilities
  #
  # Authenticated
  #  - authorization for authenticated users
  #    - all users that login will get these abilities.
  #  - part of CanCanCan abilities authorization - see ability.rb
  #
  class Authenticated
    include CanCan::Ability

    def initialize(user)
      can [:show, :create, :update], User, id: user.id
      can [:manage], [Appointment, Touch], contact_id: user.contact.id
    end
  end
end
