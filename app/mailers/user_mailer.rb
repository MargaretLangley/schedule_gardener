class UserMailer < ActionMailer::Base
  default from: "robot.gardener@#{ENV['DOMAIN']}"

  def password_reset(user)
    @user=  user
    mail = mail(to: user.email, subject: "Password Reset")
  end
end
