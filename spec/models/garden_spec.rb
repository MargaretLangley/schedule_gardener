# == Schema Information
#
# Table name: gardens
#
#  id         :integer          not null, primary key
#  contact_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Garden do
  let(:contact) do
    contact = FactoryGirl.create(:contact) 
  end
  let(:garden) do
    garden = FactoryGirl.build(:garden)
    contact.gardens << garden
    garden
  end
  let(:garden_own_address) do
    garden = FactoryGirl.build(:garden_own_address)
    contact.gardens << garden
    garden
  end


  subject { garden }
  include_examples "All Built Objects", Garden

  context "Garden with own address" do
  	subject { garden_own_address }
    it { should_not be_nil }
	  it { should be_valid }
  end

  context "Validations" do

    # would like to validate contact_id but seems to cause
    # problems. left it in as it would improve data quality
    # [ :contact_id ].each do |validate_attr|
    #   it { should validate_presence_of(validate_attr) }
    # end

  end

  context "Associations" do
  	it { should have_one(:address).dependent(:destroy)}
  	it { should belong_to(:contact)}

  	context "Addresss" do
  		context "from parent" do
			 	its(:address) { should eq garden.contact.address}
  		end
  		context "owns" do
  			subject { garden_own_address }
  			its(:address) { should_not eq garden_own_address.contact.address }
  			its(:address) { should eq garden_own_address.address }
  		end
  	end

	end

end
