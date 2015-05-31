
#
# User
#   - The physical account that identifies someone logging in.
#   - Associated with person which is the information about the user
#     - Allows a person to be present in the system but not accessible until
#       a user associates with the person.
#
# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  password_digest        :string(255)      not null
#  remember_token         :string(255)
#  password_reset_token   :string(255)
#  password_reset_sent_at :datetime
#  email_verified         :boolean          default(FALSE)
#  verify_email_token     :string(255)
#  verify_email_sent_at   :datetime
#  created_at             :datetime
#  updated_at             :datetime
#
class User < ActiveRecord::Base
  has_one :person, autosave: true, dependent: :destroy, inverse_of: :user

  has_secure_password
  validates :password, length: { minimum: 6 }, on: :create, confirmation: true

  accepts_nested_attributes_for :person
  delegate :admin?, :appointments, :calls, :email, :first_name,
           :full_name, :gardener?, :home_phone, :role, :touches, :visits, to: :person

  before_save { generate_token(:remember_token) }

  def self.find_by_email(email)
    User.joins { person }.where { (persons.email.eq(email)) }.readonly(false).first
  end

  def password_reset_token_and_password_sent_at_saved
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!
  end

  def self.search_ordered(search = nil)
    if search
      like_search =  "%#{search}%"
      users = User.joins { person }.where do
        (persons.first_name =~ like_search) |
        (persons.last_name =~ like_search) | (persons.first_name.op('||', ' ').op('||', persons.last_name) =~ like_search) |
        (persons.home_phone =~ like_search)
      end
      users.order { 'persons.first_name ASC' }
    else
      User.joins { person }.order('persons.first_name ASC')
    end
  end

  private

  def generate_token(column)
    self[column] = SecureRandom.urlsafe_base64
  end
end
