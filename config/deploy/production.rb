###################################################
#                  PRODUCTION                     #
###################################################
#
#-------------------------------------------------------------------------------
# Capistrano Standard environment settings
#
set :stage, :production
set :branch, 'master'

role :app, %w(deployer@bcs.io)
role :web, %w(deployer@bcs.io)
role :db,  %w(deployer@bcs.io)

server 'bcs.io', user: 'deployer', roles: %w(web app db), primary: true

set :rails_env, :production

#-------------------------------------------------------------------------------

#
# Unicorn
#
set :nginx_server_name, 'garden.bcs.io'
