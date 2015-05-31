#
# AppointmentIndexHelper
#   - Cleaning the Appointment Index View code
#
module AppointmentIndexHelper
  #
  # Gardeners and Clients need different meeting information
  #   - gardeners given phone number
  #   - clients given name of gardener
  #
  # appointment - the created appointment object between client and gardener
  #
  def meeting_information appointment
    if current_gardener?
      phone_without_area_code(appointment.person.home_phone)
    else
      appointment.appointee.full_name
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
