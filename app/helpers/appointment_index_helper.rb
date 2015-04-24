module AppointmentIndexHelper
  def meeting_information appointment
    if current_gardener?
      appointment_client_home_phone_without_area_code(appointment)
    else
      appointment_gardener_full_name(appointment)
    end
  end

  # Displays the minimum information to tell user when an appointment will occur
  #   - normally this is a date
  #   - if it is within the next 6 days we give a day of the week instead
  #
  # appointment - the datetime when an appoint is going to occur
  #
  def minimum_time_info appointment
    if appointment.starts_at.between?(Time.zone.now.beginning_of_day,
                                      Time.zone.now.end_of_day)
      'Today'
    elsif appointment.starts_at.between?(Time.zone.today,
                                         Time.zone.today + 6.days)
      I18n.l appointment.starts_at, format: '%a %H:%M'
    else
      I18n.l appointment.starts_at, format: :short
    end
  end
end
