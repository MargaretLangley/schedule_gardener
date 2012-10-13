# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  password_digest        :string(255)      not null
#  remember_token         :string(255)
#  admin                  :boolean          default(FALSE)
#  password_reset_token   :string(255)
#  password_reset_sent_at :datetime
#  email_verified         :boolean          default(FALSE)
#  verify_email_token     :string(255)
#  verify_email_sent_at   :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

class User < ActiveRecord::Base
  has_secure_password
  attr_accessible :contact_attributes, :password, :password_confirmation

  validates :password, presence: true, length: { minimum: 6 }, on: :create, confirmation: true
  before_save { generate_token(:remember_token) }

  has_one :contact, autosave: true, dependent: :destroy, as: :contactable
  # attr_accessible :contact_attributes - adds the attribute writer to the allowed list
  # accepts_nes.... Defines an attributes writer for the specified association
  accepts_nested_attributes_for :contact

  Roles = %w[admin client gardner]

  def full_name
    contact.full_name
  end

  def email
    contact.email
  end

  def role
    contact.role
  end

  def appointments
    contact.appointments
  end

  def visits
    contact.visits
  end

  def self.find_by_email(email)
    User.joins{contact}.where{ (contacts.email.eq(email)) }.readonly(false).first
  end

  def password_reset_token_and_password_sent_at_saved
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!
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

    def generate_token(column)
      self[column] = SecureRandom.urlsafe_base64
    end

end
