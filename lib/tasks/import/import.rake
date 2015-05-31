# Drop, Create, Migrate, Test Prepare and then populate the development
# Note: db:reset mirrors much of the calls but also db:seed which I didn't want.
# https://gist.github.com/nithinbekal/3423153
#
# rubocop: disable  Metrics/LineLength
# rubocop: disable  Metrics/MethodLength

require 'logger'
require 'optparse'

STDOUT.sync = true

desc 'Imports data from the import_data directory.'
task :import, [:import_users] => :environment do |_task, args|
  # Rails.logger = Logger.new(STDOUT)
  options = parse_options args

  Rails.logger.info 'import:truncate_all'
  Rake::Task['import:truncate_all'].invoke(options[:import_users])

  Rails.logger.info 'import:addresses'
  Rake::Task['import:addresses'].invoke

  Rails.logger.info 'import:users'
  Rake::Task['import:users'].invoke(options[:import_users])

  Rails.logger.info 'import:persons'
  Rake::Task['import:persons'].invoke

  Rails.logger.info 'import:appointment_slots'
  Rake::Task['import:appointment_slots'].invoke

  Rails.logger.info 'import:appointments'
  Rake::Task['import:appointments'].invoke

  Rails.logger.info 'import:contacts'
  Rake::Task['import:contacts'].invoke

  Rails.logger.info 'import:reset_autoincrement'
  Rake::Task['import:reset_autoincrement'].invoke
  exit 0
end

# Do add to this method until refactored!
def parse_options args
  options = {}
  OptionParser.new(args) do |opts|
    opts.banner = 'Usage: rake import -- [options]'

    options[:import_users] = true
    opts.on('-s', '--skip_users', 'skip importing users table', String) do
      options[:import_users] = false
    end

    opts.on('-h', '--help', 'Display this screen') do
      puts opts
      exit
    end
  end.parse!
  options
end
