# Drop, Create, Migrate, Test Prepare and then populate the development
# Note: db:reset mirrors much of the calls but also db:seed which I didn't want.
# https://gist.github.com/nithinbekal/3423153

STDOUT.sync = true

namespace :db do
  desc 'Get app to base state: drop, create, migrate, test:prepare and import'
  task reboot: :environment do |_tasks, _args|
    Rake::Task['db:drop'].invoke
    Rake::Task['db:create'].invoke
    Rake::Task['db:migrate'].invoke
    Rake::Task['db:test:prepare'].invoke

    exit 0
  end
end  # :db
