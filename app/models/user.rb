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

# TODO: remove Roles - does not look attached to anything. Does not break a test
# rubocop: disable Style/ConstantName

# TODO: maybe remove not that important
# rubocop: disable Style/MultilineBlockChain

class User < ActiveRecord::Base
  has_secure_password
  attr_accessible :contact_attributes, :password, :password_confirmation

  validates :password, presence: true, length: { minimum: 6 }, on: :create, confirmation: true
  before_save { generate_token(:remember_token) }

  has_one :contact, autosave: true, dependent: :destroy, as: :contactable
  delegate :appointments, :email, :first_name, :full_name, :home_phone, :role, :visits, to: :contact
  # attr_accessible :contact_attributes - adds the attribute writer to the allowed list
  # accepts_nes.... Defines an attributes writer for the specified association
  accepts_nested_attributes_for :contact

  Roles = %w(admin client gardner)

  def self.find_by_email(email)
    User.joins { contact }.where { (contacts.email.eq(email)) }.readonly(false).first
  end

  def password_reset_token_and_password_sent_at_saved
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!
  end

  def self.search_ordered(search = nil)
    if search
      like_search =  "%#{search}%"
      User.joins { contact }.where do
        (contacts.first_name =~ like_search) |
          (contacts.last_name =~ like_search) | (contacts.first_name.op('||', ' ').op('||', contacts.last_name) =~ like_search) |
          (contacts.home_phone =~ like_search)
      end.order { 'contacts.first_name ASC' }
    else
      User.joins { contact }.order('contacts.first_name ASC')
    end
  end

  private

  def generate_token(column)
    self[column] = SecureRandom.urlsafe_base64
  end
end
