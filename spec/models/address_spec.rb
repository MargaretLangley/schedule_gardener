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
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

# Address.new(street_number: "15", street_name: "High Street", address_line_2: "Stratford", town: "London", post_code: "NE12 3ST")

require 'spec_helper'

describe Address do
  subject(:address) { FactoryGirl.build(:address) }

  include_examples 'All Built Objects', Address

  context 'validations' do
    # :addressable_id, :addressable_type should be validated but validates doesn't
    # work with the create it says they are blank but the parent pointed variables
    # are assigned properly

    [:street_number, :street_name, :town].each do |present_attr|
      it { should validate_presence_of present_attr }
    end

    it { should validate_length_of(:town).is_at_most(50) }
  end

  context 'Association' do
    it { should belong_to(:addressable) }
  end
end
