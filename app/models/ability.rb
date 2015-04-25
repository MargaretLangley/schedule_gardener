
#
# Ability
#
# Authorization for the rails project
# Community follow on from RyanBate's original cancan
# https://github.com/CanCanCommunity/cancancan
#
#
# Authorizing Controller Actions
#  - most requests are authorized see link for more information
# https://github.com/CanCanCommunity/cancancan/wiki/authorizing-controller-actions
#
#
# See also:
# GoRails Video: 20-authorization-with-cancancan
#
class Ability
  include CanCan::Ability

  #
  # initialize called for any request that requires authorization
  #   - most requests are authorized
  # user - the controller's current_user
  #
  def initialize(user)
    if user
      # All Authenticated users
      Rails.logger.debug 'user role is:' + user.role

      merge Abilities::Authenticated.new(user)
      merge Abilities::Gardener.new(user) if user.gardener?
      merge Abilities::Admin.new(user) if user.admin?
    else
      # Guest users
      Rails.logger.debug 'user role is guest'

      merge Abilities::Guest.new(user)
    end
  end
end
