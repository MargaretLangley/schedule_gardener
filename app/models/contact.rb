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
  attr_accessible :address_attributes,:email, :first_name, :home_phone, :last_name, :mobile

  # Must be present, ignores validation if blank, format to REGEX
  validates :email, :first_name, :home_phone, :role, presence: true
  validates :first_name, :last_name, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]+\z/
  validates :email, allow_blank: true ,format: { with: VALID_EMAIL_REGEX }

  before_validation :set_default
  before_save       :before_save

  belongs_to  :contactable, polymorphic: true
  has_one     :address,  autosave: true, dependent: :destroy, as: :addressable
  has_many    :gardens, dependent: :destroy
  has_many    :appointments, dependent: :destroy, order: 'starts_at ASC'

  # attr_accessible :address_attributes - adds the attribute writer to the allowed list
  # accepts_nes.... Defines an attributes writer for the specified association
  accepts_nested_attributes_for :address

  def full_name
    "#{first_name} #{last_name}"
  end

  def home_phone
    read_attribute(:home_phone)
  end

  def home_phone=(num)
    write_attribute(:home_phone,num ? strip_none_numeric(num) : nil)
  end

  def mobile
    read_attribute(:mobile)
  end

  def mobile=(num)
    write_attribute(:mobile,num ? strip_none_numeric(num) : nil)
  end

  def self.contacts_by_role(role)
    Contact.where{ contacts.role == role}.order{"contacts.first_name ASC"}
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
