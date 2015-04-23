require 'csv'

namespace :import do
  task :users, [:import_users] => :environment do |_task, args|
    Rails.logger.error "Missing users: #{filename}" unless filename
    unless args.import_users
      Rails.logger.error 'Users will not be imported'
      next
    end

    CSV.foreach(filename, headers: true) do |row|
      next if row.empty?
      #
      # Bypass null password so that I don't have to store password
      # in plain text.
      User.new(row.to_hash).save(validate: false)
    end
  end

  def filename
    'import_data/users.csv'
  end
end
