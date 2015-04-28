#
# PasswordResetsController
#   - managing a user getting a new password to log in.
#
# TODO_002: remove this disable
# rubocop:  disable  Metrics/MethodLength
#
class PasswordResetsController < ApplicationController
  def new
    @password_reset = PasswordReset.new
  end

  def create
    @password_reset = PasswordReset.new(create_params)
    if @password_reset.valid?
      user = User.find_by_email(@password_reset.email)
      if user
        password_reset_and_mail_sent(user)
      else
        log_unknown_email(@password_reset.email)
      end
      redirect_to_password_reset_sent
    else
      render :new
    end
  end

  def password_reset_and_mail_sent(user)
    user.password_reset_token_and_password_sent_at_saved
    UserMailer.password_reset(user).deliver_now
  end

  def log_unknown_email(_email)
    logger.info "unknown email requested for password reset: #{@password_reset.email}"
  end

  def redirect_to_password_reset_sent
    redirect_to password_reset_sent_path, notice: 'Email sent with password reset instructions.'
  end

  def edit
    @user = User.find_by_password_reset_token!(params[:id])
    redirect_to new_password_reset_path, alert: 'Password reset has expired.' unless reset_token_valid(@user)
  end

  def reset_token_valid(user)
    (Time.zone.now - user.password_reset_sent_at) < 2.hours
  end

  def update
    @user = User.find_by_password_reset_token!(params[:id])
    if reset_token_valid(@user)
      if @user.update_attributes(user_params)
        redirect_to root_url, notice: 'Password has been reset'
      else
        render :edit
      end
    else
      redirect_to new_password_reset_path, alert: 'Password reset has expired.'
    end
  end

  private

  def create_params
    params.require(:password_reset).permit :email
  end

  def user_params
    params.require(:user)
      .permit :password,
              :password_confirmation
  end
end
