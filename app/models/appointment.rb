# == Schema Information
#
# Table name: appointments
#
#  id           :integer          not null, primary key
#  contact_id   :integer
#  appointee_id :integer
#  event_id     :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Appointment < ActiveRecord::Base

  attr_accessible :appointee_id, :contact, :event_attributes

  validates :appointee, :contact, :event, presence: true

  belongs_to :appointee, class_name: "Contact", :foreign_key => "appointee_id"
  belongs_to :contact
  belongs_to :event
  accepts_nested_attributes_for :event
end

#