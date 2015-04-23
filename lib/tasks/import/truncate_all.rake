# Trucates all the tables - except schema_migrations
# Note: db:reset mirrors much of the calls but also db:seed which I didn't want.
# https://gist.github.com/nithinbekal/3423153

STDOUT.sync = true

namespace :import do
  desc 'Truncates all the database tables'
  task :truncate_all, [:import_users] => :environment do |_task, args|
    truncate = ActiveRecord::Base.connection.tables
               .reject { |t| t == 'schema_migrations' }

    # truncate users if we are going to import users
    truncate = truncate.reject { |t| t == 'users' } unless args.import_users
    truncate.each do |table|
      ActiveRecord::Base
        .connection.execute("TRUNCATE TABLE #{table} RESTART IDENTITY;")
    end
  end
end
