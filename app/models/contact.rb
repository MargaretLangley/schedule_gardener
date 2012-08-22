# == Schema Information
#
# Table name: contacts
#
#  id         :integer         not null, primary key
#  first_name :string(255)
#  last_name  :string(255)
#  email      :string(255)
#  home_phone :string(255)
#  mobile     :string(255)
#  address_id :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class Contact < ActiveRecord::Base
	has_one         :address,  autosave: true, dependent: :destroy, as: :addressable
  belongs_to      :contactable, polymorphic: true
	attr_accessible :address_attributes,:email, :first_name, :home_phone, :last_name, :mobile
  
  # attr_accessible :address_attributes - adds the attribute writer to the allowed list
  # accepts_nes.... Defines an attributes writer for the specified association
  accepts_nested_attributes_for :address

	VALID_EMAIL_REGEX = /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]+\z/
  # Must be present, ignores validation if blank, format to REGEX
	validates :email, presence: true, allow_blank: true ,format: { with: VALID_EMAIL_REGEX }
  validates :first_name, presence: true, length: { maximum: 50 }
	validates :home_phone, presence: true
  validates :last_name, length:  { maximum: 50 }

	before_save { |contact| contact.email = email.downcase }

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

  private

    def strip_none_numeric(phone_number_string)
      phone_number_string.gsub(/\D/, '')
    end

end