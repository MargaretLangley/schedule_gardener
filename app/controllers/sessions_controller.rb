class SessionsController < ApplicationController
  def new
  end

  def create
    # Passes the emails from the sessions hash
    user = User.find_by_email(params[:session][:email])
    if user && user.authenticate(params[:session][:password])
      sign_in_remember_session(user)
      redirect_back_or dashboard_path(user)
    else
      flash.now[:alert] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    sign_out_forget_session
    redirect_to root_path
  end
end
