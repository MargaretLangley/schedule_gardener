
class AppointmentSlot < ActiveRecord::Base
  attr_accessible :humanize_time, :time, :value

  def self.slots_in_time_range(time_range)
    slots = Array.new(slots_covered_by_range(time_range)) { |i| start_slot_from_time(time_range.first) + i }
  end

  def self.start_slot_from_time(time)
    slot = find_by_time(time.strftime'%H:%M')
    unless slot
      raise "Unexpected time: #{time.strftime'%H:%M'} in AppointmentSlot.start_slot_from_time"
    end
    slot.id
  end

  def self.slots_covered_by_range(time_range)
    ((time_range.last - time_range.first) / (60 * 120.0)).round
  end

  def self.lengths
    [90,180]
  end

  def self.time_to_start_of_slot(slot_number)
      (find(slot_number)).value
  end

end
