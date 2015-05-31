require 'csv'

namespace :import do
  task persons: :environment do |_task, _args|
    Rails.logger.error "Missing persons: #{persons_file}" unless persons_file

    CSV.foreach(persons_file, headers: true) do |row|
      next if row.empty?

      Person.create!(row.to_hash)
    end
  end

  def persons_file
    'import_data/persons.csv'
  end
end
