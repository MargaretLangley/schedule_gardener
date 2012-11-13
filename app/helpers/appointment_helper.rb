module AppointmentHelper
  def appointment_client_home_phone_without_area_code(appointment = @appointment)
    number_to_phone_without_area_code(appointment.contact.home_phone)
  end
  def appointment_gardener_full_name(appointment = @appointment)
    appointment.appointee.full_name
  end

  def appointment_has_slot_booked?(appointments,slot)
    appointments &&
    appointments.any? { |appointment| appointment.include_slot_number?(slot) }
  end

  def find_appointment_for_slot(appointments,slot)
    appointments.find { |appointment| appointment.include_slot_number?(slot) }
  end

  def new_appointment_for_date_and_slot_link(date,slot)
    link_to "#{slot}", new_appointment_path(starts_at: Appointment.starts_at_from_date_and_slot(date,slot)), class: 'btn'
  end

end