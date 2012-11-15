
class AppointmentSlot < ActiveRecord::Base
  attr_accessible :humanize_time, :time, :value

  def self.slots_covered_by_time(start_time, duration)
    slots = Array.new(duration_to_covered_slots(duration)) { |i| start_slot_from_time(start_time) + i }
  end

  def self.start_slot_from_time(time)
    slot = find_by_time(time)
    unless slot
      raise "Unexpected time: #{time} in AppointmentSlot.start_slot_from_time"
    end
    slot.id
  end

  def self.duration_to_covered_slots(duration)
    (duration / 120.0).round
  end

  def self.lengths
    [90,180]
  end

  def self.time_to_start_of_slot(slot_number)
      (find(slot_number)).value
  end

end
