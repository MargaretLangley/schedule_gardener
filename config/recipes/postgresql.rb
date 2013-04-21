set_default(:postgresql_host, "localhost")
set_default(:postgresql_user) { application }

set_default(:postgresql_password) { Capistrano::CLI.ui.ask("#{application} PostgreSQL Password: ") }
set_default(:postgresql_database) { "#{application}_production" }
set_default(:postgresql_pid) { "/var/run/postgresql/9.2-main.pid" }

namespace :postgresql do
  desc "Create a database for this application."
  task :create_database, roles: :db, only: {primary: true} do
    answer = Capistrano::CLI.ui.ask("To create Role and Database, type 'yes' anything else and role and database creation is skipped.")
    if answer == 'yes'
      # If you need secrecy Capistrano::CLI.password_prompt
      run %Q{#{sudo} -u postgres psql -c "create user #{postgresql_user} with password '#{postgresql_password}';"}
      run %Q{#{sudo} -u postgres psql -c "create database #{postgresql_database} owner #{postgresql_user};"}
    end
  end
  after "deploy:setup", "postgresql:create_database"

  desc "Drop the database and role for this application."
  task :drop, roles: :db, only: { primary: true } do
    # drop the database and role
    run %Q{#{sudo} -u postgres psql -c "DROP DATABASE #{postgresql_database};"}
    run %Q{#{sudo} -u postgres psql -c "DROP ROLE #{postgresql_user};"}
  end

  desc "Generate the database.yml configuration file."
  task :setup, roles: :app do
    run "mkdir -p #{shared_path}/config"
    template "postgresql.yml.erb", "#{shared_path}/config/database.yml"
  end
  after "deploy:setup", "postgresql:setup"

  desc "Symlink the database.yml file into latest release"
  task :symlink, roles: :app do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end
  after "deploy:finalize_update", "postgresql:symlink"



  task :ask_drop_confirmation do
    set(:confirmed) do
      puts <<-WARN

      ========================================================================

               WARNING: You're about to drop the database
               and role on a production server.

      ========================================================================

      WARN
      answer = Capistrano::CLI.ui.ask "If you are sure you want to continue type 'yes'"
      if answer == 'yes' then true else false end
    end

    unless fetch(:confirmed)
      puts "\nDatabase will not be changed."
      exit
    end
  end

  before "postgresql:drop", "postgresql:ask_drop_confirmation"


  # lib/tasks/kill_postgres_connections.rake
  task :kill_connections do
    db_name = "#{postgresql_database}"
    sh = <<-EOF
    ps xa \
      | grep postgres: \
      | grep #{db_name} \
      | grep -v grep \
      | awk '{print $1}' \
      | sudo xargs kill
    EOF
    # puts `#{sh}`
    run "#{sudo} #{sh}"
  end
  # after "postgresql:ask_drop_confirmation", "postgresql:kill_connections"

  desc "copies the local development database to the remote production."
  task :pdrestore do
    # start_banner("wiping out and restoring the PRODUCTION Database")
    run_locally "pg_dump -Fc --no-acl --no-owner #{application}_development > pdrestore.dump"
    run_locally "pg_restore --verbose --clean --no-acl --no-owner -h '#{host}' -U #{application} -d #{application}_production -p 5432 pdrestore.dump"
    run_locally 'rm pdrestore.dump'
  end


end