# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
ScheduleGardener::Application.initialize!


# Configuration for using SendGrid on Heroku
ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
  :user_name => ENV['EMAIL_USERNAME'],
  :password => ENV['EMAIL_PASSWORD'],
  :domain => ENV['DOMAIN'],
  :address => "smtp.sendgrid.net",
  :port => 587,
  :authentication => :plain,
  :enable_starttls_auto => true
}
