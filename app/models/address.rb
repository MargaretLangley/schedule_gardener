# == Schema Information
#
# Table name: addresses
#
#  id               :integer         not null, primary key
#  addressable_id   :integer
#  addressable_type :string(255)
#  house_name       :string(255)
#  street_number    :string(255)
#  street_name      :string(255)
#  address_line_2   :string(255)
#  town             :string(255)
#  post_code        :string(255)
#  created_at       :datetime        not null
#  updated_at       :datetime        not null
#

class Address < ActiveRecord::Base
  attr_accessible :house_name,:street_number, :street_name, :address_line_2, :town, :post_code

  belongs_to :addressable, polymorphic: true
  # Does not allow you to validate id and type, probably a bug
  # validates  :addressable_id, presence: true
  # validates  :addressable_type, presence: true

  validates :street_number, presence: true
  validates :street_name, presence: true
  validates :town, presence: true, length: { maximum: 50 }
  
end
