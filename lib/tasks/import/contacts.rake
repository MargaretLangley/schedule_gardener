require 'csv'

namespace :import do
  task contacts: :environment do |_task, _args|
    Rails.logger.error "Missing contacts: #{contacts_file}" unless contacts_file

    CSV.foreach(contacts_file, headers: true) do |row|
      Contact.create!(row.to_hash)
    end
  end

  def contacts_file
    'import_data/contacts.csv'
  end
end
