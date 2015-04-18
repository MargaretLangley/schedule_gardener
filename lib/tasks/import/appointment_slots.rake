require 'csv'

namespace :import do
  task appointment_slots: :environment do |_task, _args|
    Rails.logger.error "Missing appointment slots: #{slots_file}" unless slots_file

    CSV.foreach(slots_file, headers: true) do |row|
      AppointmentSlot.create!(row.to_hash)
    end
  end

  def slots_file
    'import_data/appointment_slots.csv'
  end
end
