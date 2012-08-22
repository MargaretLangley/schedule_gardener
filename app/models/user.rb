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
#  home_phone    :string(255)
#  admin           :boolean         default(FALSE)
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#

class User < ActiveRecord::Base
  has_secure_password
  has_one :contact, autosave: true, dependent: :destroy, as: :contactable
  attr_accessible :contact_attributes, :password, :password_confirmation

  # attr_accessible :address_attributes - adds the attribute writer to the allowed list
  # accepts_nes.... Defines an attributes writer for the specified association
  accepts_nested_attributes_for :contact

  validates :password, presence: true, length: { minimum: 6 }, on: :create
	validates :password_confirmation, presence: true, on: :create
  before_save :create_remember_token

  def first_name
    contact.first_name
  end

  def last_name
    contact.last_name 
  end

  def email
    contact.email
  end

  def self.find_by_email(email)
    User.joins{contact}.where{ (contacts.email.eq(email)) }.first
  end

  def self.search_ordered(search = nil)
    if search
      like_search =  "%#{search}%"
      User.joins{contact}.where{(contacts.first_name =~ like_search) | 
                               (contacts.last_name =~ like_search)   |
                               (contacts.first_name.op('||', ' ').op('||', contacts.last_name) =~ like_search) |
                               (contacts.home_phone =~ like_search) 
                                }.order{"contacts.first_name ASC"}
    else
      User.joins{contact}.order('contacts.first_name ASC')                     
    end
  end

  private

    def create_remember_token
      # SecureRandom generates a unique (though really should check it's unique)
      self.remember_token = SecureRandom.urlsafe_base64
    end

end
    