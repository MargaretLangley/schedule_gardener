#
# Person
#
# The information about an entity in the system
#   - persons have the information to complete the creation of an appointment
#
# == Schema Information
#
# Table name: persons
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  first_name :string(255)      not null
#  last_name  :string(255)      not null
#  email      :string(255)
#  home_phone :string(255)      not null
#  mobile     :string(255)
#  role       :string(255)      not null
#  created_at :datetime
#  updated_at :datetime
#
class Person < ActiveRecord::Base
  enum role: { client: 0, gardener: 1, admin: 2 }
  belongs_to :user, inverse_of: :person
  has_one :address,  autosave: true, dependent: :destroy, as: :addressable
  has_many :gardens, dependent: :destroy

  # Gardener
  has_many :visits, -> { order(starts_at: :asc) }, class_name: 'Appointment', foreign_key: 'appointee_id', dependent: :destroy
  has_many :calls, -> { order(touch_from: :asc) }, class_name: 'Contact', foreign_key: 'appointee_id', dependent: :destroy

  # Client
  has_many :appointments, -> { order(starts_at: :asc) }, foreign_key: 'person_id', dependent: :destroy
  has_many :contacts, -> { order(touch_from: :asc) }, foreign_key: 'person_id', dependent: :destroy

  accepts_nested_attributes_for :address

  validates :address, :first_name, :last_name, :home_phone, :role, :user, presence: true
  validates :first_name, :last_name, length: { maximum: 50 }
  validates :email, allow_blank: true, email_format: true

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

  def self.by_role(role)
    Person.where('role = ?', Person.roles[role])
      .order(first_name: :asc)
  end

  private

  def strip_none_numeric(phone_number_string)
    phone_number_string.gsub(/\D/, '')
  end

  def before_save
    self.email = email.downcase if email.present?
  end
end
