require 'csv'
#
# Output data to CSV file
#  - different from postgresql
#    - date time includes timezone information
#    - date time missing ms which might be important on other dbs
#      - maybe an i18n issue - outputting a default time format?
#
desc 'Exports data to the import_data directory.'
task export:  :environment do
  CSV.open('import_data/addresses.csv', 'w') do |csv|
    csv << Address.attribute_names
    Address.all.each do |address|
      csv << address.attributes.values
    end
  end

  CSV.open('import_data/persons.csv', 'w') do |csv|
    csv << Person.attribute_names
    Person.all.each do |person|
      csv << person.attributes.merge('role' => person.role).values
    end
  end

  CSV.open('import_data/users.csv', 'w') do |csv|
    csv << User.attribute_names
    User.all.each do |user|
      csv << user.attributes.merge('remember_token' => nil).values
    end
  end

  CSV.open('import_data/appointment_slots.csv', 'w') do |csv|
    csv << AppointmentSlot.attribute_names
    AppointmentSlot.all.each do |appointment_slot|
      csv << appointment_slot.attributes.values
    end
  end

  CSV.open('import_data/appointments.csv', 'w') do |csv|
    csv << Appointment.attribute_names
    Appointment.all.each do |appointment|
      csv << appointment.attributes.values
    end
  end

  CSV.open('import_data/contacts.csv', 'w') do |csv|
    csv << Contact.attribute_names
    Contact.all.each do |contact|
      csv << contact.attributes.values
    end
  end
end
