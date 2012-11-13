module AppointmentHelper
  def appointment_client_home_phone_without_area_code(appointment = @appointment)
    number_to_phone_without_area_code(appointment.contact.home_phone)
  end
  def appointment_gardener_full_name(appointment = @appointment)
    appointment.appointee.full_name
  end

end