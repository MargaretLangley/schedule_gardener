module Abilities
  #
  # Guest
  #  - authorization for authenticated users
  #    - guests are users that have not authenticated
  #  - part of CanCanCan abilities authorization - see ability.rb
  #
  class Guest
    include CanCan::Ability

    def initialize(*)
      can [:create], [User]
    end
  end
end
