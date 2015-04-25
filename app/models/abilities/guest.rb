module Abilities
  class Guest
    include CanCan::Ability

    def initialize(*)
      can [:create], [User]
    end
  end
end
