class UserMailer < ActionMailer::Base
  default from: "robot.gardener@#{Rails.application.secrets.DOMAIN}"

  def password_reset(user)
    @user = user
    mail(to: user.email, subject: 'Password Reset')
  end
end
