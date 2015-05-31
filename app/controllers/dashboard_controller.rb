#
# DashboardController
#  - the gardening 'lowdown' - what is import to know
#
class DashboardController < ApplicationController
  before_action :guest_redirect_to_signin_path
  check_authorization
  load_and_authorize_resource :user, parent: false

  def show
    @user = current_user
    if current_user.gardener?
      @appointments = current_user.visits.includes(:person)
      @touches = current_user.calls.outstanding.includes(:person)
    else
      @appointments = current_user.appointments.includes(:person)
      @touches = current_user.touches.outstanding.includes(:person)
    end
  end
end
