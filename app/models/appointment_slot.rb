class AppointmentSlot < ActiveRecord::Base
  attr_accessible :humanize_time, :time, :value

  def self.booked(start_time,length)
    start_slot = time_to_slot_number(start_time)
    slots_booked_from_length(length) == 1  ? [ start_slot ] : [ start_slot, start_slot + 1]
  end

  def self.time_to_slot_number(time)
    slot = find_by_time(time)
    unless slot
      raise "Unexpected time: #{time} in AppointmentSlot.time_to_slot_number"
    end
    slot.id
  end

  APPOINTMENT_LENGTH = {
    single: 90,
    double: 210
  }

  def self.slots_booked_from_length(length)
    number_of_slots = case length
    when APPOINTMENT_LENGTH[:single] then 1
    when APPOINTMENT_LENGTH[:double] then 2
    else
      raise "Unexpected length of appointment: #{length} in AppointmentSlot.slots_booked_from_length"
    end
  end

  def self.time_from_date_and_slot(date,slot_number)
    date + time_to_start_of_slot(slot_number).minutes
  end

  def self.time_to_start_of_slot(slot_number)
      (find(slot_number)).value
  end


end
