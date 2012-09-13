class SessionsController < ApplicationController

  def new
  end

  def create
    # Passes the emails from the sessions hash
    user = User.find_by_email(params[:session][:email])
    if user && user.authenticate(params[:session][:password])
      # sets the cookie to user's remember_token and current_user to "user"
      sign_in user
      redirect_back_or user
    else
      flash.now[:error] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end
end