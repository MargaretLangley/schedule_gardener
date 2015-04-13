#
# Contact
#
# The person we contact about gardening
#   - contacts have the information to complete the creation of an appointment
#

# == Schema Information
#
# Table name: contacts
#
#  id               :integer          not null, primary key
#  contactable_id   :integer
#  contactable_type :string(255)
#  first_name       :string(255)      not null
#  last_name        :string(255)
#  email            :string(255)
#  home_phone       :string(255)      not null
#  mobile           :string(255)
#  role             :string(255)      not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
class Contact < ActiveRecord::Base
  attr_accessible :address_attributes, :email, :first_name, :home_phone, :last_name, :mobile

  belongs_to :contactable, polymorphic: true
  has_one :address,  autosave: true, dependent: :destroy, as: :addressable
  accepts_nested_attributes_for :address
  has_many :gardens, dependent: :destroy
  has_many :appointments, dependent: :destroy, order: 'appointments.starts_at ASC'
  has_many :touches
  has_many :visits, class_name: 'Appointment', foreign_key: 'appointee_id', dependent: :destroy, order: 'appointments.starts_at ASC'

  validates :email, :first_name, :home_phone, :role, presence: true
  validates :first_name, :last_name, length: { maximum: 50 }
  validates :email, allow_blank: true, email_format: true

  before_validation :set_default
  before_save :before_save

  def full_name
    "#{first_name} #{last_name}"
  end

  def home_phone
    self[:home_phone]
  end

  def home_phone=(num)
    self[:home_phone] = num ? strip_none_numeric(num) : nil
  end

  def mobile
    self[:mobile]
  end

  def mobile=(num)
    self[:mobile] = num ? strip_none_numeric(num) : nil
  end

  def self.contacts_by_role(role)
    Contact.where { contacts.role == role }.order { 'contacts.first_name ASC' }
  end

  private

  def strip_none_numeric(phone_number_string)
    phone_number_string.gsub(/\D/, '')
  end

  def set_default
    self.role ||= 'client'
  end

  def before_save
    self.email = email.downcase
  end
end
