class PasswordResetsController < ApplicationController
  def new
    @password_reset = PasswordReset.new
  end

  def create
    @password_reset = PasswordReset.new(params[:password_reset])
    if @password_reset.valid?
      user = User.find_by_email(@password_reset.email)
      if user
        user.password_reset_token_and_password_sent_at_saved
        UserMailer.password_reset(user).deliver
      else
        logger.info "unknown email requested for password reset:" #{}" #{@password_reset.email}"
      end
      redirect_to password_reset_sent_path, notice:"Email sent with password reset instructions."
    else
      render :new
    end
  end

  def edit
    @user = User.find_by_password_reset_token!(params[:id])
  end

  def update
    @user = User.find_by_password_reset_token!(params[:id])
    if @user.password_reset_sent_at < 2.hours.ago
      redirect_to new_password_reset_path, alert: "Password reset has expired."
    elsif @user.update_attributes(params[:user])
      redirect_to root_url, notice: "Password has been reset"
    else
        render :edit
    end

  end
end

