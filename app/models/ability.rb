
#
# Ability
#
# Authorization for the rails project
# Community follow on from RyanBate's original cancan
# https://github.com/CanCanCommunity/cancancan
#
# See also:
# GoRails Video: 20-authorization-with-cancancan
#
# TODO: remove these
# rubocop: disable Metrics/MethodLength, disable Style/UnlessElse
#
class Ability
  include CanCan::Ability

  #
  # user - the current_user
  #
  def initialize(user)
    unless user
      # Guest
      Rails.logger.debug 'user role is guest'
      can [:create], [User]

    else
      # All Registered users
      Rails.logger.debug 'user role is:' + user.role

      can [:show, :create, :update], User, id: user.id
      can [:manage], [Appointment, Touch], contact_id: user.contact.id
      # Different Roles
      case user.role
      when 'client'
        # nothing more to do
      when 'gardener'
        can :manage, [Appointment, Touch]
        can [:read, :create, :update], User
      when 'admin'
        can :manage, :all
        cannot :destroy, user, id: user.id
      else
        fail "Missing Role: #{user.role} in Ability#initialize"
      end
    end
  end
end
