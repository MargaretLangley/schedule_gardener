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
#  person_id :integer
#  created_at :datetime
#  updated_at :datetime
#
class Garden < ActiveRecord::Base
  belongs_to :person
  has_one :address, autosave: true, dependent: :destroy, as: :addressable

  accepts_nested_attributes_for :address

  validates :address, :person, presence: true

  alias_method :garden_address, :address
  def address
    # owned address || parent address
    garden_address || person.address
  end
end
