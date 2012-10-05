set :application, "schedule_gardener"
#set :repository,  "set your repository location here"
# puts "hello #{fetch(:application,"world")}"

#set :staging  "git@heroku.com:gardener-staging.git"

set :scm, :git


task :stpush   do
  puts "#{application} code to staging"
  run_locally 'git push staging master'
end

task :stmig do
  run_locally 'heroku run rake db:migrate --remote staging'
  run_locally 'heroku ps --remote staging'
end

task :stinfo  do
  puts "#{application} pg information"
  system 'heroku pg:info --remote staging'
end

task :stpsql do
  puts "#{application} Remote Staging Database"
  system 'heroku pg:psql HEROKU_POSTGRESQL_PURPLE --remote staging'
end

task :strestore do
  run_locally 'pg_dump -Fc --no-acl --no-owner schedule_gardener_development > data.dump'
  run_locally 'pg_restore -W --verbose --clean --no-acl --no-owner -h ec2-54-243-235-169.compute-1.amazonaws.com -U alawohniburtoq -d dcgonjhl76emj8 -p 5432 data.dump'
  run_locally 'rm data.dump'
end


task :pdpush do
  puts "\n\n*********************************************************************************"
  puts "****** #{application} updating the PRODUCTION Web server ********"
  puts "*********************************************************************************\n\n"

 system 'git push production master'
end

task :pdinfo  do
  system 'heroku pg:info --remote production'
end

task :pdpsql do
  puts "*** #{application} Remote PRODUCTION Database ***"
  system 'heroku pg:psql HEROKU_POSTGRESQL_MAROON --remote production'
end


task :pdrestore do
  puts "\n\n*********************************************************************************"
  puts "****** #{application} wiping out and resoring the PRODUCTION Database ********"
  puts "*********************************************************************************\n\n"
  run_locally 'pg_dump -Fc --no-acl --no-owner schedule_gardener_development > data.dump'
  run_locally 'pg_restore -W --verbose --clean --no-acl --no-owner -h ec2-54-243-190-152.compute-1.amazonaws.com -U cuzufrejeteocm -d d1re16pjjfhcp7 -p 5432 data.dump'
  run_locally 'rm data.dump'
end


task :pdbackup do
  puts "#{application} Backing up PRODUCTION Database"
  system 'curl -o latest.dump `heroku pgbackups:url --app furious-mouse`'
  system 'pg_restore -O --clean -d schedule_gardener_development latest.dump'
end

#https://devcenter.heroku.com/articles/multiple-environments
#https://github.com/capistrano/capistrano/wiki/2.x-Getting-Started
