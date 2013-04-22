require "bundler/capistrano"
require "capistrano-rbenv"

load "config/recipes/base"
load "config/recipes/nginx"
load "config/recipes/unicorn"
load "config/recipes/postgresql"
load "config/recipes/check"
load "config/recipes/monit"

set  :host, "193.183.99.251"
server "#{host}", :web, :app, :db, primary: true
# set :server_name, "draca.co.uk www.draca.co.uk"
set :server_name, "business-consolidating-services.com  www.business-consolidating-services.com"

set :user, "deployer"
set :application, "schedule_gardener"  #change
set :owner, "BCS-io" #change
set :deploy_to, "/home/#{user}/apps/#{application}"
set :deploy_via, :remote_cache
set :use_sudo, false

set :scm, "git"
set :repository, "git@github.com:#{owner}/#{application}.git"
set :branch, "master"
set :rbenv_ruby_version, "1.9.3-p392"

set :maintenance_template_path, File.expand_path("../recipes/templates/maintenance.html.erb", __FILE__)

default_run_options[:pty] = true
ssh_options[:forward_agent] = true
# ssh_options[:keys] = [File.join(ENV["HOME"], ".vagrant.d", "insecure_rivate_key")]

after "deploy", "deploy:cleanup" # keep only the last 5 releases

