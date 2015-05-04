#
# Configuration File to Deploy Schedule Gardener
#
#   - Supplies general variables that Capistrano uses to deploy software
#   - Other files supply environment specific settings:
#       -  /config/deploy/production.rb
#          /config/deploy/staging.rb
#
#
#-------------------------------------------------------------------------------
#
# Capistrano Standard Application
#
lock '3.4.0'

set :application, 'schedule_gardener'
set :user, 'deployer'

set :full_app_name, "#{fetch(:application)}_#{fetch(:stage)}"
set :deploy_to, "/home/#{fetch(:user)}/apps/#{fetch(:full_app_name)}"

set :keep_releases, 3

#
# SCM
#
set :scm, :git
set :repo_url, 'git@github.com:BCS-io/schedule_gardener.git'
set :branch, ENV['REVISION'] || ENV['BRANCH_NAME']

#-------------------------------------------------------------------------------

#
# db-tasks (and assets) - sgruhier/capistrano-db-tasks
#
set :db_local_clean, true      # remove the local dump file after loading
set :db_remote_clean, true     # remove the dump file from the server after downloading

set :assets_dir, %w(public/assets public/att)
set :local_assets_dir, %w(public/assets public/att)

#
# rbenv
#
set :rbenv_type, :system
set :rbenv_ruby, '2.2.2'
set :rbenv_custom_path, '/opt/rbenv'

#
# Unicorn
#
set :unicorn_workers, 2
