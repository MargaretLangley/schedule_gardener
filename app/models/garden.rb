#
# Garden
#
# The physical garden's location
#   - a garden to work on can be at a different address from the contact address
#
# == Schema Information
#
# Table name: gardens
#
#  id         :integer          not null, primary key
#  contact_id :integer
#  created_at :datetime
#  updated_at :datetime
#

class Garden < ActiveRecord::Base
  belongs_to :contact
  has_one :address, autosave: true, dependent: :destroy, as: :addressable

  accepts_nested_attributes_for :address

  validates :address, :contact, presence: true

  alias_method :garden_address, :address
  def address
    # owned address || parent address
    garden_address || contact.address
  end
end
