#
# Touch
#
# A request for work
#
#  - TODO: not sure if we are entering a contract to do the work?
#    - best guess is yes
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
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
class Touch < ActiveRecord::Base
  attr_accessible :additional_information, :between_end, :between_start, :completed, :contact, :contact_id, :by_phone, :by_visit, :touch_from, :visit_at
  belongs_to :contact
  delegate :full_name, :home_phone, to: :contact

  validates :contact_id, presence: true
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

  def self.all_ordered
    Touch.joins { contact }.order { 'touches.touch_from ASC, contacts.first_name ASC' }
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
