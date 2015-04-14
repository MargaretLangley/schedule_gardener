module AppointmentHelper
  def appointment_client_home_phone_without_area_code(appointment = @appointment)
    number_to_phone_without_area_code(appointment.contact.home_phone)
  end

  def appointment_gardener_full_name(appointment = @appointment)
    appointment.appointee.full_name
  end

  #
  # appointment_filled?
  #  - appointments is the collection of appointments
  #  - slot is the slot we want to know is booked or not
  #
  #  - returns true if filled, false if unfilled
  #
  def appointment_filled?(appointments, slot)
    appointments &&
      appointments.any? { |appointment| appointment.include_slot_number?(slot) }
  end

  #
  # find_appointment
  #  - appointments is the collection of appointments
  #  - slot is the slot we want to know is booked or not
  #
  #  - returns appointment if it can be found, nil if not
  #
  def find_appointment(appointments, slot)
    appointments.find { |appointment| appointment.include_slot_number?(slot) }
  end

  #
  # link to generate appointment with associated start_time
  #   - date is the date of the appointment
  #   - slot is the slot in the day which has a range of 1 to 4
  #
  #   - returns a link to a new_appointment at a specific start time
  #
  def new_appointment_link(date, slot)
    link_to "#{slot}", new_appointment_path(starts_at: date + AppointmentSlot.time_to_start_of_slot(slot)), class: 'btn'
  end
end
