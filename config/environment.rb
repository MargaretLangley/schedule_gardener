# Load the rails application.
require File.expand_path('../application', __FILE__)

# Initialize the rails application.
Rails.application.initialize!

# Configuration for using SendGrid on Heroku
ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.default_url_options = { host: Rails.application.secrets.DOMAIN }
ActionMailer::Base.smtp_settings = {
  user_name: Rails.application.secrets.EMAIL_USERNAME,
  password: Rails.application.secrets.EMAIL_PASSWORD,
  domain: Rails.application.secrets.DOMAIN,
  address: 'smtp.sendgrid.net',
  port: 587,
  authentication: :plain,
  enable_starttls_auto: true
}
