class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user, :signed_in?, :current_user?, :admin?


  # sign_in saves the user in the cookie
  def sign_in(user)
    # set the cookie eq to the unique identifier, remember_token, kept in each user
    cookies.permanent[:remember_token] = user.remember_token
    self.current_user = user
  end

  def sign_out
    self.current_user = nil
    cookies.delete(:remember_token)
  end

  def current_user=(user)
    @current_user = user
  end

    #  only people who are signed in can access users pages
  def guest_redirect_to_signin_path
    unless signed_in?
      store_current_path
      redirect_to signin_path, notice: 'Please sign in.'
    end
  end

  def signed_in?
    current_user.present?
  end

  def current_user
    @current_user ||= User.find_by_remember_token(cookies[:remember_token])
  end

  def store_current_path
    session[:return_to_path] = request.fullpath
  end


  def redirect_back_or(default)
    redirect_to(session[:return_to_path] || default)
    session.delete(:return_to_path)
  end

  def user_from_param
    @user = User.find(params[:id])
  end


  def current_user?(user)
    user == current_user
  end

  def admin?
    user.admin?
  end

  rescue_from CanCan::AccessDenied do |exception|
    logger.debug "CanCan::AccessDenied Controller: #{exception.subject.class} Action: #{exception.action}"
    sign_out
    redirect_to root_url, :alert => exception.message
  end

end