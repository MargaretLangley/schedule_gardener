ScheduleGardener::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # The test environment is used exclusively to run your application's
  # test suite. You never need to work with it otherwise. Remember that
  # your test database is "scratch space" for the test suite and is wiped
  # and recreated between test runs. Don't rely on the data there!

 require 'yaml'
  yaml_data = YAML::load(ERB.new(IO.read(File.join(Rails.root, 'config', 'sensitive_information.yml'))).result)
  APP_CONFIG = HashWithIndifferentAccess.new(yaml_data)

  config.cache_classes = true

  # Configure static asset server for tests with Cache-Control for performance
  config.serve_static_assets = true
  config.static_cache_control = "public, max-age=3600"

  # Log error messages when you accidentally call methods on nil
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Raise exceptions instead of rendering exception templates
  config.action_dispatch.show_exceptions = false

  # Disable request forgery protection in test environment
  config.action_controller.allow_forgery_protection    = false

  # Tell Action Mailer not to deliver emails to the real world.
  # The :test delivery method accumulates sent emails in the
  # ActionMailer::Base.deliveries array.
  config.action_mailer.delivery_method = :test

    # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = true

  config.action_mailer.default_url_options = {
    :host => '127.0.0.1',
    :port => 3000
  }

  # Change mail delvery to either :smtp, :sendmail, :file, :test
  config.action_mailer.delivery_method = :smtp
    config.action_mailer.smtp_settings = {
    address: "smtp.gmail.com",
    port: 587,
    domain: "sutton.garden.care.com",
    authentication: "plain",
    enable_starttls_auto: true,
    user_name: "Garden.Care.Mail.Server@gmail.com",
    password: "WuxZJrcuB8DwtuVBP8"
  }

  # Raise exception on mass assignment protection for Active Record models
  config.active_record.mass_assignment_sanitizer = :strict

  # Print deprecation notices to the stderr
  config.active_support.deprecation = :stderr

  #speed up tests by lowering BCrypt's cost function
  require 'bcrypt'
  silence_warnings do
    BCrypt::Engine::DEFAULT_COST = BCrypt::Engine::MIN_COST
  end
end
