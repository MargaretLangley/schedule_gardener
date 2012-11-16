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

  attr_accessible :appointee, :appointee_id, :contact, :contact_id, :description, :ends_at, :starts_at

  validates :appointee, :contact, :starts_at, presence: true
  validates_datetime :starts_at, after: :now, before: :this_date_next_year
  validates_datetime :ends_at, on_or_after: :starts_at

  belongs_to :contact, class_name: "Contact", foreign_key: 'contact_id'
  belongs_to :appointee, class_name: "Contact", foreign_key: 'appointee_id'

  after_initialize :initialize_datetimes

  def initialize_datetimes
    self.starts_at ||= Time.zone.now.beginning_of_day + 1.day
    self.ends_at ||= Time.zone.now.beginning_of_day + 1.day
  end

  class AppointmentTime
    attr_accessor :date
    attr_accessor :time
    attr_accessor :length
    def persisted?; false; end
  end

  attr_accessible :appointment_time_attributes
  has_one :appointment_time
  accepts_nested_attributes_for :appointment_time


  def appointment_time
    t = AppointmentTime.new
    t.date = self.starts_at
    t.time = self.starts_at.strftime'%H:%M'
    t.length = self.start_end_difference_in_minutes
    t
  end

  def start_end_difference_in_minutes
    self.ends_at - self.starts_at == 0 ? 0 : ((self.ends_at - self.starts_at) /60).floor
  end

  def appointment_time_attributes=(hash)
    self.starts_at = format_date_and_time_accessors_for_database(hash)
    self.ends_at = calculate_ends_at(hash[:length])
  end

  def format_date_and_time_accessors_for_database(hash)
    "#{starts_at_date_to_db_format(hash[:date])} #{starts_at_time_string(hash[:time])}"
  end

  def starts_at_date_to_db_format(date)
    DateTime.strptime(date,'%d %b %Y').strftime('%F')
  end

  def starts_at_time_string(time)
    Time.zone.parse(time + ":00").strftime'%H:%M:%S'
  end

  def calculate_ends_at(length_of_appointment)
    self.starts_at + length_of_appointment.to_i.minutes
  end

  def title
    contact.first_name
  end

  def include_slot_number?(slot_number)
    AppointmentSlot.slots_in_time_range(starts_at..ends_at).include? slot_number
  end

  def self.in_time_range(time_range)
    where { (starts_at.in time_range) | (ends_at.in time_range) }
  end

end
