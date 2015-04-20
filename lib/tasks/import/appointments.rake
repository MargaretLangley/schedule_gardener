require 'csv'

namespace :import do
  task appointments: :environment do |_task, _args|
    Rails.logger.error "Missing appointment file: #{appointments_file}" unless appointments_file

    CSV.foreach(appointments_file, headers: true) do |row|
      next if row.empty?
      Appointment.new(row.to_hash).save(validate: false)
    end
  end

  def appointments_file
    'import_data/appointments.csv'
  end
end
