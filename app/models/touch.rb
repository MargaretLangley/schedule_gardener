# == Schema Information
#
# Table name: touches
#
#  id                     :integer          not null, primary key
#  contact_id             :integer
#  by_phone               :boolean
#  by_visit               :boolean
#  touch_from             :datetime
#  between_start          :datetime
#  between_end            :datetime
#  completed              :boolean
#  additional_information :text
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

class Touch < ActiveRecord::Base
  belongs_to :contact
  attr_accessible :additional_information, :between_end, :between_start, :completed, :contact, :contact_id, :by_phone, :by_visit, :touch_from, :visit_at
  validates_datetime :between_start, on_or_after: :today, on_or_before: :this_date_next_year
  validates_datetime :between_end, on_or_after: :between_start, on_or_before: :this_date_next_year
  validates_datetime :touch_from, on_or_after: :today, on_or_before: :this_date_next_year
  validate :touch_by_method_must_be_selected

  after_initialize :initialize_record

  def initialize_record
    self.by_phone ||= false
    self.by_visit ||= false
    self.touch_from ||= Time.zone.now.beginning_of_day
    self.between_start ||= Time.zone.now.beginning_of_day
    self.between_end ||= Time.zone.now.beginning_of_day + 1.year
    self.additional_information ||= ''
    self.completed ||= false
  end

  def self.completed()
    Touch.joins{contact}.where{ touches.completed == false}.order{'touches.touch_from ASC, contacts.first_name ASC'}
  end


  def touch_by_method_must_be_selected
    errors.add(:by_phone, 'You have to select a way to contact us. Either choose by phone or by visit.')  unless (self.by_phone? || self.by_visit?)
  end

end
