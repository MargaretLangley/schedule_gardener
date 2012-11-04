class DashboardController < ApplicationController
  before_filter :guest_redirect_to_signin_path
  check_authorization

  def show
    @user = current_user
    if current_user.role == "gardener"
      @touches = Touch.outstanding()
    else
      @touches = Touch.outstanding_by_contact(current_user.contact)
    end
    authorize! :show, @user
  end
end
