require 'csv'

namespace :import do
  task users: :environment do |_task, _args|
    Rails.logger.error "Missing users: #{filename}" unless filename

    CSV.foreach(filename, headers: true) do |row|
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
