#
# Touch
#
# A request for work
#
#  - From a gardener it is the intent to contact someone
#  - From a client it is a request to be contacted
#
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
#  created_at             :datetime
#  updated_at             :datetime
#

class Touch < ActiveRecord::Base
  belongs_to :contact
  delegate :full_name, :home_phone, to: :contact

  validates :contact, presence: true
  validates :touch_from,
            date: { after_or_equal_to: proc { Time.zone.now },
                    before: proc { Time.zone.now + 1.year },
                    message: 'We can contact you from today. Please choose a date which can be today or in the future.' }
  validate :touch_by_method_must_be_selected

  after_initialize :initialize_record

  def initialize_record
    self.by_phone ||= false
    self.by_visit ||= false
    self.touch_from ||= Time.zone.now
    self.additional_information ||= ''
    self.completed ||= false
  end

  def self.outstanding
    Touch.joins { contact }.where { touches.completed == false }.order { 'touches.touch_from ASC, contacts.first_name ASC' }
  end

  def self.outstanding_by_contact(by_contact)
    Touch.joins { contact }.where { (touches.completed == false) & (touches.contact_id == by_contact.id) }.order { 'touches.touch_from ASC, contacts.first_name ASC' }
  end

  def touch_by_method_must_be_selected
    errors.add(:by_phone, 'You have to select a way to contact us. Either choose by phone or by visit.')  unless self.by_phone? || self.by_visit?
  end
end
