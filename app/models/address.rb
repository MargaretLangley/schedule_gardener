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
  # Does not allow you to validate id and type, probably a bug
  # validates  :addressable_id, :addressable_type, presence: true

  validates :street_number, presence: true
  validates :street_name, presence: true
  validates :town, presence: true, length: { maximum: 50 }

  belongs_to :addressable, polymorphic: true
end
