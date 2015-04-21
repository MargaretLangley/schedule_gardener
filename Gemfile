#
# Gemfile
#
# Keeping a Gemfile up to date and especially updated Gems with security issues
# is an important maintenance task.
#
# 1) Which Gems are out of date?
# 2) Update a Gem
# 3) Gemfile.lock
# 4) Versioning
# 5) Importance of a Gem to the Application
# 6) Resetting Gems back to the original version
# 7) Breaking Gem List
#
#
# 1) Which Gems are out of date?
#
# bundle outdated  or use https://gemnasium.com/BCS-io/letting
#
#
# 2) Update a Gem
#
#  Update a single Gem using bundle update < gem name >
#    - example of pg: bundle update gp
#
# If a gem has not changed check what restrictions the Gemfile specifies
# Taking pg as an example again. We can update to 0.18.1, 0.18.2, 0.18.3
# but not update to 0.19.1. To update to 0.19.1 you need to change the Gem
# statement in this file and then run bundle update as above.
#
# gem 'pg', '~>0.18.0'     =>      gem 'pg', '~>0.19.0'
#
# After updating a gem run rake though and if it passes before pushing up.
#
#
# 3) Gemfile.lock
#
# You should never change Gemfile.lock directly. By changing Gemfile and
# running bundle commands you change Gemfile.lock indirectly.
#
#
# 4) Versioning
#
# Most Gems follow Semantic Versioning:  http://semver.org/
#
# Risk of causing a problem:
# Low: 0.18.0 => 0.18.X        - bug fixes
# Low-Medium: 0.18.0 => 0.19.0 - New functionality but should not break old
#                                functionality.
# High:       0.18 = > 1.0.0   - Breaking changes with past code.
#
#
# 5) Importance of a Gem to the Application
#
# Gems which are within development will not affect the production application:
#
#  group :development do
#    gem 'better_errors', '~> 2.1.0'
#  end
#
# Gems without a block will affect the production application and you should be
# more careful with the update.
#
#
# 6) Resetting Gems back to the original version
#
# If you need to return your Gems to original version.
# a) git checkout .
# b) bundle install
#

#
# GEMS THAT BREAK THE BUILD
#
# A list of Gems that if updated will break the application.
#
# Gem                     Using      Last tested   Gem Bug
# byebug                  3.5.1            4.0.3         Y
#

source 'https://rubygems.org'
ruby '2.1.2'

#
# Production
#
gem 'rails', '~> 4.2.1'

gem 'active_attr', '~> 0.8.0'
gem 'bootstrap-sass', '~> 3.3.4'
gem 'bootstrap-datepicker-rails', '~> 1.4.0'
gem 'bcrypt-ruby', '~> 3.1.0'
gem 'bootstrap-will_paginate', '~> 0.0.0'
gem 'cancancan', '~> 1.10'
gem 'coffee-rails', '~> 4.1.0'
gem 'date_validator', '~> 0.7.0'
gem 'figaro', '~> 1.1.0'
gem 'jquery-rails', '~> 3.1.2'
gem 'jquery-ui-rails', '~> 5.0.0'
gem 'jquery-rest-rails', '~> 1.0.0'
gem 'lograge', '~> 0.3.0'
gem 'pg', '~> 0.18.0'
gem 'simple_form', '~> 3.1.0'
gem 'rails_admin', '~> 0.6.7'
gem 'rails-i18n', '~> 0.7.0'
gem 'rake', '~> 10.4.0'
gem 'sass-rails',   '~> 5.0.0'
gem 'sdoc', '~> 0.4.0',          group: :doc
gem 'squeel', '~> 1.2.0'
gem 'turbolinks', '~> 2.5.0'
gem 'uglifier', '~> 2.7.0'
gem 'unicorn', '~> 4.8.0'
gem 'validates_timeliness', '~> 3.0'
gem 'will_paginate', '~> 3.0.0'

#
# Capistrano deployment
#
group :development do
  gem 'airbrussh', require: false
  gem 'capistrano', '~> 3.4.0'
  gem 'capistrano-bundler', '~> 1.1.3'

  #
  # Upgrading to 0.4.0 caused
  # createdb: database creation failed: ERROR:  permission denied to create
  gem 'capistrano-db-tasks', '0.3', require: false
  gem 'capistrano-postgresql', '~> 4.2.0'
  gem 'capistrano-rails', '~> 1.1.2'
  gem 'capistrano-rbenv', '~> 2.0.0'
  gem 'capistrano-rails-collection', '~> 0.0.3'
  gem 'capistrano-unicorn-nginx', github: 'BCS-io/capistrano-unicorn-nginx'
  gem 'mascherano', '~> 1.1.0'
end

group :development do
  gem 'annotate', '~> 2.6.0'
  gem 'rails-erd', '~> 1.3.0'
  gem 'rubocop', '~> 0.30.0', require: false
  gem 'scss-lint'
end

group :development, :test do
  #
  # BREAKING GEM
  # Throwing exceptions when it hits breakpoints
  #
  gem 'byebug', '3.5.1'
  gem 'rb-readline'
  gem 'rspec-rails', '~> 3.2.0'
  gem 'spring'
  gem 'table_print'
  gem 'web-console', '~> 2.0'
end

group :test do
  gem 'capybara', '~> 2.4.0'
  gem 'capybara-screenshot'
  gem 'coveralls', '~>0.8.0', require: false
  gem 'database_cleaner', '~> 1.4.0'
  gem 'factory_girl_rails', '~> 4.5.0'
  gem 'shoulda-matchers'
  gem 'timecop', '~>0.7.0'
  gem 'zonebie'
end
