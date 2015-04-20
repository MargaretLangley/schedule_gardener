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
task :import, [:test] => :environment do |_task, args|
  # Rails.logger = Logger.new(STDOUT)

  options = parse_options args

  Rails.logger.info 'import:truncate_all'
  Rake::Task['import:truncate_all'].execute

  Rails.logger.info 'import:addresses'
  Rake::Task['import:addresses'].invoke(options[:test])

  Rails.logger.info 'import:contacts'
  Rake::Task['import:contacts'].invoke(options[:test])

  Rails.logger.info 'import:users'
  Rake::Task['import:users'].invoke(options[:test])

  Rails.logger.info 'import:appointment_slots'
  Rake::Task['import:appointment_slots'].invoke(options[:test])

  Rails.logger.info 'import:appointments'
  Rake::Task['import:appointments'].invoke(options[:test])

  Rails.logger.info 'import:touches'
  Rake::Task['import:touches'].invoke(options[:test])

  Rails.logger.info 'import:reset_autoincrement'
  Rake::Task['import:reset_autoincrement'].invoke
  exit 0
end

# Do add to this method until refactored!
def parse_options args
  options = {}
  OptionParser.new(args) do |opts|
    opts.banner = 'Usage: rake db:import -- [options]'

    options[:test] = false
    opts.on('-t', '--test', "Make users with password 'password'", String) do
      options[:test] = true
    end

    opts.on('-h', '--help', 'Display this screen') do
      puts opts
      exit
    end
  end.parse!
  options
end
