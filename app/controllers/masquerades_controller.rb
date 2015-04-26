#
# Masquerade
#  - allows a user to pretend to be another user
#    - typically an admin to be a standard user
#  - used to see the application as a standard user to deal with problems.
#
#  new - starts a new masquerade session
#  destroy - ends a masquerade session
#
# https://robots.thoughtbot.com/how-to-masquerade-as-another-user-to-see-how-they-use-yo
#
class MasqueradesController < ApplicationController
  before_action :guest_redirect_to_signin_path
  check_authorization
  authorize_resource class: false

  def new
    session[:masked_id] = current_user.id
    user = User.find(params[:user_id])
    sign_in_remember_session(user)
    redirect_to root_path, notice: "Now masquerading as #{user.full_name}"
  end

  def destroy
    user = User.find(session[:masked_id])
    session[:masked_id] = nil
    sign_in_remember_session(user)
    redirect_to root_path, notice: 'Stopped masquerading'
  end
end
