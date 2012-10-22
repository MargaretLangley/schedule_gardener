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
  attr_accessor  :starts_at_date, :length_of_appointment

  validates :appointee, :contact, :starts_at, :starts_at_date, :starts_at_time, :length_of_appointment, presence: true
  validates_datetime :starts_at, after: :now, before: :this_date_next_year
  validates_datetime :ends_at, on_or_after: :starts_at

  belongs_to :contact, class_name: "Contact", foreign_key: 'contact_id'
  belongs_to :appointee, class_name: "Contact", foreign_key: 'appointee_id'

  after_initialize :initialize_datetimes
  before_validation :accessors_synchronise_model

  def initialize_datetimes
    nil_datetimes_initialised
    model_synchronise_accessors
  end

  def nil_datetimes_initialised
    self.starts_at ||= Time.zone.now.beginning_of_day + 1.day
    self.ends_at ||= Time.zone.now.beginning_of_day + 1.day
  end

  def model_synchronise_accessors
    self.starts_at_date ||= self.starts_at.strftime('%d %b %Y')
    self.starts_at_time ||= self.starts_at.strftime'%H:%M'
    self.length_of_appointment ||=  start_end_difference_in_minutes
  end

  def start_end_difference_in_minutes
    self.ends_at - self.starts_at == 0 ? 0 : ((self.ends_at - self.starts_at) /60).floor
  end


  def accessors_synchronise_model
    self.starts_at = format_datetime_for_database
    self.ends_at = calculate_ends_at
    rescue ArgumentError
     errors.add(:starts_at, 'must be a valid datetime')
  end

  def format_datetime_for_database
    "#{date_string_to_db} #{utc_time_string_to_db}"
  end

  def date_string_to_db
    DateTime.strptime(self.starts_at_date,'%d %b %Y').strftime('%F')
  end


  def utc_time_string_to_db
    Time.zone.parse(self.starts_at_time + ":00").utc.strftime'%H:%M:%S'
  end

  def calculate_ends_at
    self.starts_at + length_of_appointment.to_i.minutes
  end

  def title
    contact.first_name
  end

  def self.after_now()
     where { starts_at > Time.zone.now }
  end

  def self.in_time_range(time_range)
      where { (starts_at.in time_range) | (ends_at.in time_range) }
  end

end
