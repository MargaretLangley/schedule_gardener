class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user, :signed_in?, :current_user?, :current_gardener?
  include PersistPath

  def sign_in_remember_session(user)
    # remember_token is a unique identifier
    cookies.permanent[:remember_token] = user.remember_token
    self.current_user = user
  end

  def sign_out_forget_session
    self.current_user = nil
    cookies.delete(:remember_token)
  end

  def current_user
    @current_user ||= User.find_by_remember_token(cookies[:remember_token])
  end

  def current_admin?
    current_user && current_user.role == 'admin'
  end

  def current_gardener?
    current_user && current_user.role == 'gardener'
  end

  attr_writer :current_user

  #  only people who are signed in can access users pages
  def guest_redirect_to_signin_path
    return if signed_in?

    store_path
    redirect_to signin_path, notice: 'Please sign in.'
  end

  def signed_in?
    current_user.present?
  end

  def redirect_back_or(default_path)
    redirect_to_stored_path_else_default_path(default_path)
    clear_path
  end

  def current_user?(user)
    user == current_user
  end

  rescue_from CanCan::AccessDenied do |exception|
    logger.debug "CanCan::AccessDenied Controller: #{exception.subject.class} Action: #{exception.action}"
    sign_out_forget_session
    redirect_to root_url, alert: exception.message
  end
end
