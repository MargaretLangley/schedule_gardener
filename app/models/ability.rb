
# Define abilities for the passed in user here. For example:
#
# The first argument to `can` is the action you are giving the user permission to do.
# If you pass :manage it will apply to every action. Other common actions here are
# :read, :create, :update and :destroy.
#
# The second argument is the resource the user can perform the action on. If you pass
# :all it will apply to every resource. Otherwise pass a Ruby class of the resource.
#
# The third argument is an optional hash of conditions to further filter the objects.
# For example, here the user can only update published articles.
#
#   can :update, Article, :published => true
#
# See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities


class Ability
  include CanCan::Ability

  def initialize(user)


    # Guest
    unless user
      Rails.logger.debug  "user role is guest"
      can :create, [User]
    else
      # All Registered users
      Rails.logger.debug "user role is:" + user.contact.role.to_s

      can [:show, :new, :create, :update ], User, id: user.id
      can :manage, Appointment, contact_id: user.contact.id
      # Different Roles
      case user.contact.role
      when "client"
        # nothing more to do
      when "gardener"
          can :manage, :all
      when "admin"
          can :manage, :all
          cannot :destroy, user, id: user.id
      else
        raise "Missing Role: #{user.contact.role} in Ability#initialize"
      end
    end
  end
end
