#
# Mail configuration for Mandrill
#
#
ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.default_url_options = { host: Rails.application.secrets.HOST }
ActionMailer::Base.default charset: 'utf-8'

smtp_settings = {
  domain: Rails.application.secrets.DOMAIN,
  authentication: :login,
  enable_starttls_auto: true,
  openssl_verify_mode: 'none'
}

#
# 'test' smtp server breaks in development / test if you pass authentication
#
if Rails.env.production?
  smtp_settings.merge!(address: Rails.application.secrets.SMTP_ADDRESS,
                       port: Rails.application.secrets.SMTP_PORT,
                       user_name: Rails.application.secrets.EMAIL_USERNAME,
                       password: Rails.application.secrets.EMAIL_PASSWORD)
end

ActionMailer::Base.smtp_settings  = smtp_settings
