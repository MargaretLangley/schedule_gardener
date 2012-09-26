# == Schema Information
#
# Table name: gardens
#
#  id         :integer          not null, primary key
#  contact_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Garden < ActiveRecord::Base
  attr_accessible :address_attributes

  # NOT SURE... look at this
  #validates  :contact_id, presence: true

  has_one    :address,  autosave: true, dependent: :destroy, as: :addressable
  belongs_to :contact

  # attr_accessible :address_attributes - adds the attribute writer to the allowed list
  # accepts_nes.... Defines an attributes writer for the specified association
  accepts_nested_attributes_for :address

  alias_method :garden_address, :address
  def address
    #      owned address       || parent address
    return self.garden_address || contact.address
  end

end
