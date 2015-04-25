#
# AppointmentSlot
#
module AppointmentSlotHelper
  # slot_lengths
  # - creates collection of formatted hours and minutes and minutes
  #   - formatted hours are for display only
  #   - minutes are used by actual model
  #
  def slot_lengths
    AppointmentSlot
      .lengths.map { |length| [format_minutes_as_hrs_mins(length), length]  }
  end
end
