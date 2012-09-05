class Garden < ActiveRecord::Base
  attr_accessible :address_attributes

  validates  :contact_id, presence: true
  
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
