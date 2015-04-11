source 'https://rubygems.org'

gem 'rails', '3.2.21'

gem 'active_attr'
gem 'bootstrap-sass'
gem 'bootstrap-datepicker-rails'
gem 'bcrypt-ruby', '3.0.1'
gem 'bootstrap-will_paginate'
gem 'cancan'
gem 'figaro'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'jquery-rest-rails'
gem 'pg', '~>0.18.0'
gem 'simple_form', '2.0.2'
gem 'rails_admin'
gem 'rails-i18n'
gem 'rake'
gem 'squeel'
gem 'unicorn'
gem 'validates_timeliness', '~> 3.0'
gem 'will_paginate'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
end

#
# Capistrano deployment
#
group :development do
  gem 'capistrano', '~> 2.14.2'
  gem 'capistrano-rbenv'
end

group :development do
  gem 'annotate', '2.5.0'
  gem 'rubocop', '~> 0.29.0', require: false
  gem 'quiet_assets'
  gem 'rails-erd'
end

group :development, :test do
  gem 'debugger'
  gem 'rspec-rails', '2.14.0'
  gem 'rb-inotify'
  gem 'libnotify'
  gem 'rb-readline'
end

group :test do
  gem 'factory_girl_rails'
  gem 'capybara', '~> 2.4.0'
  gem 'capybara-screenshot'
  gem 'shoulda-matchers'
  gem 'coveralls', '~>0.7.0', require: false
  gem 'timecop', '~>0.7.0'
end
