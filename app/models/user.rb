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
  attr_accessible :first_name,     :last_name
  attr_accessible :email
  attr_accessible :password,       :password_confirmation
  attr_accessible :address_line_1, :address_line_2
  attr_accessible :town,           :post_code
  attr_accessible :phone_number
  attr_accessible :garden_requirements
  has_secure_password
  validates :first_name, presence: true, length: { maximum: 50 }
  validates :last_name, length:  { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]+\z/
	validates :email, allow_blank: true, format: { with: VALID_EMAIL_REGEX }
	validates :password, length: { minimum: 6 }, on: :create
	validates :password_confirmation, presence: true, on: :create
  validates :town, presence: true, length: { maximum: 50 }
  validates :address_line_1, presence: true
  validates :phone_number, presence: true

  before_save { |user| user.email = email.downcase }
  before_save :create_remember_token

  def phone_number
    read_attribute(:phone_number)
  end

  # Really doesn't like gsub!
  def phone_number=(num)
    write_attribute(:phone_number,num.gsub(/\D/, ''))
  end

  def self.search_ordered(search = nil)
    if search
      where('first_name LIKE ? OR last_name LIKE ? OR phone_number LIKE ?', "%#{search}%", "%#{search}%", "%#{search}%").order('first_name ASC')
    else
      scoped.order('first_name ASC')
    end
  end

  private

    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end

end
