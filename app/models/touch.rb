# == Schema Information
#
# Table name: touches
#
#  id                     :integer          not null, primary key
#  contact_id             :integer          not null
#  by_phone               :boolean
#  by_visit               :boolean
#  touch_from             :datetime         not null
#  completed              :boolean
#  additional_information :text
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

class Touch < ActiveRecord::Base
  belongs_to :contact
  attr_accessible :additional_information, :between_end, :between_start, :completed, :contact, :contact_id, :by_phone, :by_visit, :touch_from, :visit_at
  validates :contact_id, presence: true
  validates_datetime :touch_from, on_or_after: :today, before: :this_date_next_year
  validate :touch_by_method_must_be_selected

  after_initialize :initialize_record

  def initialize_record
    self.by_phone ||= false
    self.by_visit ||= false
    self.touch_from ||= Time.zone.now.beginning_of_day
    self.additional_information ||= ''
    self.completed ||= false
  end

  def self.all_ordered()
    Touch.joins{contact}.order{'touches.touch_from ASC, contacts.first_name ASC'}
  end

  def self.outstanding()
    Touch.joins{contact}.where{ touches.completed == false}.order{'touches.touch_from ASC, contacts.first_name ASC'}
  end

  def self.outstanding_by_contact(by_contact)
    Touch.joins{contact}.where{ (touches.completed == false) & (touches.contact_id == by_contact.id)}.order{'touches.touch_from ASC, contacts.first_name ASC'}
  end



  def touch_by_method_must_be_selected
    errors.add(:by_phone, 'You have to select a way to contact us. Either choose by phone or by visit.')  unless (self.by_phone? || self.by_visit?)
  end

end
