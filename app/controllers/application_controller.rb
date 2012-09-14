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

  def current_user
    @current_user ||= User.find_by_remember_token(cookies[:remember_token])
  end

  def signed_in?
    !current_user.nil?
  end

  def admin?
    user.admin?
  end

  def current_user?(user)
    user == current_user
  end


  def store_location
    session[:return_to] = request.fullpath
  end

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end

    #  only people who are signed in can access users pages
  def signed_in_user
    # signed_in? means sessions helper has the @user set
    unless signed_in?
      store_location
      redirect_to signin_path, notice: 'Please sign in.' unless signed_in?
    end
  end


  def allowed_admin_user
    unless current_user.admin?
      sign_out
      redirect_to(root_path)
    end
  end


  # clicking an edit link sets id to the user you clicked
  # current user assigns @current_user from cookie if null
  # current user is the user returned from the cookie
  def allowed_user
    @user = User.find(params[:id])
    unless (current_user?(@user) || current_user.admin?)
      sign_out
      redirect_to(root_path)
    end
  end

end