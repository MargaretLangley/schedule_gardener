require 'csv'

namespace :import do
  task addresses: :environment do |_task, _args|
    Rails.logger.error "Missing addresses: #{addresses_file}" unless addresses_file

    CSV.foreach(addresses_file, headers: true) do |row|
      next if row.empty?
      Address.create!(row.to_hash)
    end
  end

  def addresses_file
    'import_data/addresses.csv'
  end
end
