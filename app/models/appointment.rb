#
# Appointment
#
# Physical appointment - represents the intention to complete a job of work
#                        between a contact and a gardener within a time range.
#
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
  attr_accessible :appointment_time_attributes
  belongs_to :contact, class_name: 'Contact', foreign_key: 'contact_id'
  belongs_to :appointee, class_name: 'Contact', foreign_key: 'appointee_id'

  #
  # TODO: appointment_time is a method to convert from start_at, end_at to
  #       DateAndTimeRange
  #
  has_one :appointment_time
  accepts_nested_attributes_for :appointment_time

  validates :appointee, :contact, :starts_at, presence: true
  validates_datetime :starts_at, after: :now, before: :this_date_next_year
  validates_datetime :ends_at, on_or_after: :starts_at

  # This code could replace the above and then remove validates_timeliness
  # validates :starts_at, date: { after: proc { Time.zone.now },
  #                               before: proc { Time.zone.now + 1.year } }
  # validates :ends_at, date: { after_or_equal_to: :starts_at }

  after_initialize :initialize_datetimes

  def initialize_datetimes
    self.starts_at ||= Time.zone.now.beginning_of_day + 1.day
    self.ends_at ||= Time.zone.now.beginning_of_day + 1.day
  end

  def appointment_time
    DateAndTimeRange.new(start: starts_at, end: ends_at)
  end

  def appointment_time_attributes=(hash)
    datr = DateAndTimeRange.new(start_date: hash[:start_date],
                                start_time: hash[:start_time],
                                length: hash[:length])
    self.starts_at = datr.start.datetime
    self.ends_at = datr.end.datetime
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
