# == Schema Information
#
# Table name: users
#
#  id              :integer         not null, primary key
#  first_name      :string(255)
#  last_name       :string(255)
#  email           :string(255)
#  password_digest :string(255)
#  remember_token  :string(255)
#  phone_number    :string(255)
#  admin           :boolean         default(FALSE)
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#

class User < ActiveRecord::Base
  has_one         :address,  autosave: true, dependent: :destroy, as: :addressable
  attr_accessible :first_name,     :last_name
  attr_accessible :email
  attr_accessible :password,       :password_confirmation
  attr_accessible :phone_number
  # Defines an attributes writer for the specified association
  accepts_nested_attributes_for :address
  # adds the attribute writer to the allowed list
  attr_accessible :address_attributes

  has_secure_password
  validates :first_name, presence: true, length: { maximum: 50 }
  validates :last_name, length:  { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]+\z/
  # Must be present, ignores validation if blank, format to REGEX
	validates :email, presence: true, allow_blank: true ,format: { with: VALID_EMAIL_REGEX }
	validates :password, length: { minimum: 6 }, on: :create
	validates :password_confirmation, presence: true, on: :create
  validates :phone_number, presence: true

  before_save { |user| user.email = email.downcase }
  before_save :create_remember_token

  def phone_number
    read_attribute(:phone_number)
  end

  def phone_number=(num)
    write_attribute(:phone_number,num ? num.gsub(/\D/, '') : nil)
  end

  def self.search_ordered(search = nil)
    if search
      where("first_name ILIKE ? OR last_name ILIKE ? OR (first_name || ' ' || last_name) ILIKE ? OR phone_number LIKE ?", 
            "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%"
           )
           .order('first_name ASC')
    else
      scoped.order('first_name ASC')
    end
  end

  private

    def create_remember_token
      # SecureRandom generates a unique (though really should check it's unique)
      self.remember_token = SecureRandom.urlsafe_base64
    end

end
