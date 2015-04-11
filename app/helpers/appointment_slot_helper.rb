module AppointmentSlotHelper
  def slot_lengths
    AppointmentSlot.lengths.map { |length| [format_minutes_as_hrs_mins(length), length]  }
  end
end
