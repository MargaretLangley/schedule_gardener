set :application,     "schedule_gardener"
set :dump_options,    "-Fc --no-acl --no-owner"
set :restore_options, "--verbose --clean --no-acl --no-owner"

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

task :stlogs do
 system 'heroku logs -t --remote staging'
end

task :stpsql do
  puts "#{application} Remote Staging Database"
  system 'heroku pg:psql HEROKU_POSTGRESQL_PURPLE --remote staging'
end

task :strestore do
  start_banner("wiping out and resoring the STAGING Database")
  run_locally "pg_dump #{dump_options} #{application}_development > tmp/schedule_gardener.dump"
  run_locally "pg_restore -W #{restore_options} -h ec2-54-243-235-169.compute-1.amazonaws.com -U alawohniburtoq -d dcgonjhl76emj8 -p 5432 tmp/schedule_gardener.dump"
  run_locally 'rm tmp/schedule_gardener.dump'
end

def start_banner (title)
  puts "\n\n" + "*" * 80
  puts "*" + " " * 78 + "*"
  puts "*" * 10 + " #{application} #{title} " + "*" * 10
  puts "*" + " " * 78 + "*"
  puts "*" * 80 + "\n\n"
end

task :pdpush do
  start_banner("updating the PRODUCTION Web server")
  system 'git push production master'
end

task :pdinfo  do
  system 'heroku pg:info --remote production'
end

task :pdpsql do
  start_banner("Remote PRODUCTION Database")
  system 'heroku pg:psql HEROKU_POSTGRESQL_MAROON --remote production'
end


task :pdrestore do
  start_banner("wiping out and resoring the PRODUCTION Database")
  run_locally "pg_dump #{dump_options} #{application}_development > data.dump"
  run_locally "pg_restore -W #{restore_options} -h ec2-54-243-190-152.compute-1.amazonaws.com -U cuzufrejeteocm -d d1re16pjjfhcp7 -p 5432 data.dump"
  run_locally 'rm data.dump'
end


task :pdbackup do
  start_banner("Backing up PRODUCTION Database, drops and restores local")
  puts "backing up local database"
  run_locally "pg_dump #{dump_options} #{application}_development > tmp/#{application}_backup.dump"
  puts "#{application} Capturing...."
  system 'heroku pgbackups:capture --expire --app gardener-production'
  puts "#{application} Copied to local...."
  system 'curl -o tmp/latest.dump `heroku pgbackups:url --app gardener-production`'
  puts "drop local database and create"
  system "rake db:drop"
  system "rake db:create"
  puts "#{application} replacing the local database...."
  system "pg_restore #{restore_options} -d #{application}_development tmp/latest.dump"

  puts "prepare test db"
  system 'rake db:test:prepare'
end

# More ideas while getting hang of scripts ... must remove comments!
#https://devcenter.heroku.com/articles/multiple-environments
#https://github.com/capistrano/capistrano/wiki/2.x-Getting-Started
#https://gist.github.com/2577832