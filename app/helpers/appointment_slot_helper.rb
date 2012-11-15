module AppointmentSlotHelper

def slot_lengths
  AppointmentSlot.lengths.map {|length| [distance_time_to_hours_and_minutes(length), length]  }
end



end