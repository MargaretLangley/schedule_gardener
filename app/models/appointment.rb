# == Schema Information
#
# Table name: appointments
#
#  id           :integer          not null, primary key
#  contact_id   :integer
#  appointee_id :integer
#  starts_at    :datetime         not null
#  ends_at      :datetime         not null
#  description  :text
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#


class Appointment < ActiveRecord::Base

  attr_accessible :appointee, :appointee_id, :contact, :contact_id, :description, :ends_at, :length_of_appointment, :starts_at, :starts_at_date, :starts_at_time
  attr_accessor  :starts_at_date, :starts_at_time, :length_of_appointment

  validates :appointee, :contact, :starts_at, :starts_at_date, :starts_at_time, :length_of_appointment, presence: true
  validates_datetime :starts_at, after: :now, before: :this_date_next_year
  validates_datetime :ends_at, on_or_after: :starts_at

  belongs_to :contact, class_name: "Contact", foreign_key: 'contact_id'
  belongs_to :appointee, class_name: "Contact", foreign_key: 'appointee_id'

  after_initialize :initialize_datetimes
  before_validation :accessors_synchronise_model

  APPOINTMENT_SLOTS = {
    '1' =>  '09:30',
    '2' =>  '11:30',
    '3' =>  '13:30',
    '4' =>  '15:30'
  }

  APPOINTMENT_LENGTH = {
    single: 90,
    double: 210
  }

  def initialize_datetimes
    nil_datetimes_initialised
    model_synchronise_accessors
  end

  def nil_datetimes_initialised
    self.starts_at ||= Time.zone.now.beginning_of_day + 1.day
    self.ends_at ||= Time.zone.now.beginning_of_day + 1.day
  end

  def model_synchronise_accessors
    self.starts_at_date ||= starts_at_return_date
    self.starts_at_time ||= starts_at_return_time
    self.length_of_appointment ||=  start_end_difference_in_minutes
  end

  def starts_at_return_date
    self.starts_at.strftime('%d %b %Y')
  end

  def starts_at_return_time
    self.starts_at.strftime'%H:%M'
  end

  def start_end_difference_in_minutes
    self.ends_at - self.starts_at == 0 ? 0 : ((self.ends_at - self.starts_at) /60).floor
  end

  def accessors_synchronise_model
    self.starts_at = format_date_and_time_accessors_for_database
    self.ends_at = calculate_ends_at
    rescue ArgumentError
     errors.add(:starts_at, 'must be a valid datetime')
  end

  def format_date_and_time_accessors_for_database
    "#{starts_at_date_to_db_format} #{starts_at_time_string}"
  end

  def starts_at_date_to_db_format
    DateTime.strptime(self.starts_at_date,'%d %b %Y').strftime('%F')
  end


  def starts_at_time_string
    Time.zone.parse(self.starts_at_time + ":00").strftime'%H:%M:%S'
  end

  def calculate_ends_at
    self.starts_at + length_of_appointment.to_i.minutes
  end

  def title
    contact.first_name
  end

  def include_slot_number?(slot_number)
    booked_slots.include? slot_number
  end

  def booked_slots
    start_slot = start_at_to_slot_number
    appointment_length_to_slot_number == 1 ? [ start_slot ] : [ start_slot, start_slot + 1]
  end

  def start_at_to_slot_number
      start_slot = case starts_at_return_time
      when APPOINTMENT_SLOTS['1'] then 1
      when APPOINTMENT_SLOTS['2'] then 2
      when APPOINTMENT_SLOTS['3'] then 3
      when APPOINTMENT_SLOTS['4'] then 4
      else
        raise "Unexpected Starts_at: #{starts_at_return_time} in Appointment#start_slot"
      end
  end

  def appointment_length_to_slot_number
    number_of_slots = case length_of_appointment
    when APPOINTMENT_LENGTH[:single] then 1
    when APPOINTMENT_LENGTH[:double] then 2
    else
      raise "Unexpected length of appointment: #{length_of_appointment} in Appointment#start_slot"
    end
  end

  def self.starts_at_from_date_and_slot(date,slot_number)
    date + slot_number_to_hours_and_minutes(slot_number)
  end

  def self.slot_number_to_hours_and_minutes(slot_number)
      case slot_number
      when 1 then 9.hours  + 30.minutes
      when 2 then 11.hours + 30.minutes
      when 3 then 13.hours + 30.minutes
      when 4 then 15.hours + 30.minutes
      else
        raise "Unexpected Starts_at: #{starts_at_return_time} in Appointment#start_slot"
      end
  end

  def self.in_time_range(time_range)
      where { (starts_at.in time_range) | (ends_at.in time_range) }
  end

end
