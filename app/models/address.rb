#
# Address
#   - the information in a home address
#
# == Schema Information
#
# Table name: addresses
#
#  id               :integer          not null, primary key
#  addressable_id   :integer
#  addressable_type :string(255)
#  house_name       :string(255)
#  street_number    :string(255)      not null
#  street_name      :string(255)      not null
#  address_line_2   :string(255)
#  town             :string(255)      not null
#  post_code        :string(255)
#  created_at       :datetime
#  updated_at       :datetime
#
class Address < ActiveRecord::Base
  belongs_to :addressable, polymorphic: true

  validates :street_number, :street_name, presence: true
  validates :town, presence: true, length: { maximum: 50 }
end
