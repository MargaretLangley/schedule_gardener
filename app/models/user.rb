# == Schema Information
#
# Table name: users
#
#  id                  :integer         not null, primary key
#  first_name          :string(255)
#  last_name           :string(255)
#  email               :string(255)
#  address_line_1      :string(255)
#  address_line_2      :string(255)
#  town                :string(255)
#  post_code           :string(255)
#  phone_number        :string(255)
#  garden_requirements :text
#  created_at          :datetime        not null
#  updated_at          :datetime        not null
#

class User < ActiveRecord::Base
  attr_accessible :first_name
  attr_accessible :last_name
  attr_accessible :email
  attr_accessible :password
  attr_accessible :password_confirmation
  attr_accessible :address_line_1
  attr_accessible :address_line_2
  attr_accessible :town
  attr_accessible :post_code
  attr_accessible :phone_number
  attr_accessible :garden_requirements
  has_secure_password
  validates :first_name, presence: true, length: { maximum: 50 }
  validates :last_name, presence: true, length:  { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]+\z/
	validates :email, presence: true, uniqueness: { case_sensitive: false}, format: { with: VALID_EMAIL_REGEX }
	validates :password, presence: true, length: { minimum: 6 }
	validates :password_confirmation, presence: true
  validates :town, presence: true, length: { maximum: 50 }
  validates :address_line_1, presence: true
  validates :phone_number, presence: true

  before_save { self.email = email.downcase! }
end
