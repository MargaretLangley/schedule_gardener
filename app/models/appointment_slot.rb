#
# AppointmentSlot
#
# Appointment slot records hold the time when you can get an appointment
# This object provides methods to query times based on slot number and
# time we can book for.
#
# rubocop: disable Lint/UselessAssignment
#
# == Schema Information
#
# Table name: appointment_slots
#
#  id            :integer          not null, primary key
#  time          :string(255)      not null
#  humanize_time :string(255)      not null
#  value         :integer          not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
class AppointmentSlot < ActiveRecord::Base
  attr_accessible :humanize_time, :time, :value

  def self.slots_in_time_range(time_range)
    slots = Array.new(slots_covered_by_range(time_range)) do |i|
      start_slot_from_time(time_range.first) + i
    end
  end

  # start_slot_from_time(time)
  # Arg
  # time - time to match against
  # returns - a slot which has a start time equal to time argument
  #
  def self.start_slot_from_time(time)
    slot = find_by(time: time.strftime('%H:%M'))
    unless slot
      fail "Unexpected time: #{time.strftime '%H:%M'} in AppointmentSlot.start_slot_from_time"
    end
    slot.id
  end

  # slot_number - the slot we are considering (1 to 4)
  # returns time in minutes to the start of the slot
  #
  def self.time_to_start_of_slot(slot_number)
    (find(slot_number)).value
  end

  #
  # How many slots are covered given a time range
  #
  def self.slots_covered_by_range(time_range)
    ((time_range.last - time_range.first) / (60 * 120.0)).round
  end

  def self.lengths
    [90, 180]
  end
end
