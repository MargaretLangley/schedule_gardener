#
# ApplicationController
#
#  - base class application controller
#
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user, :signed_in?, :current_admin?, :current_user?, :current_gardener?
  include StorePath

  # saves current user
  #  - assumes we have authenticated
  #
  def sign_in_remember_session(user)
    # remember_token is a unique identifier
    cookies.permanent[:remember_token] = user.remember_token
    self.current_user = user
  end

  # forgets current user
  #
  def sign_out_forget_session
    self.current_user = nil
    cookies.delete(:remember_token)
  end

  # Get user from user database
  #
  def current_user
    @current_user ||= User.find_by_remember_token(cookies[:remember_token])
  end

  attr_writer :current_user

  def signed_in?
    current_user.present?
  end

  def current_user?(user)
    user == current_user
  end

  def current_admin?
    current_user && current_user.admin?
  end

  def current_gardener?
    current_user && current_user.gardener?
  end

  # Authenticated users continue using application
  #   - unauthenticated users are ask to authenticate
  #
  def guest_redirect_to_signin_path
    return if signed_in?

    store_path
    redirect_to signin_path, notice: 'Please sign in.'
  end

  def masquerading?
    session[:masked_id].present?
  end
  helper_method :masquerading?

  rescue_from CanCan::AccessDenied do |exception|
    logger.debug "CanCan::AccessDenied Controller: #{exception.subject.class} Action: #{exception.action}"
    sign_out_forget_session
    redirect_to root_url, alert: exception.message
  end
end
