require 'spec_helper'

describe Garden do
  let(:garden) { FactoryGirl.build(:garden)}
  subject { garden }
  include_examples "All Built Objects", Garden

  context "Garden with address" do
  	subject(:garden_own_address) { FactoryGirl.build(:garden_own_address)}
  	it { should_not be_nil }
	  it { should be_valid }
  end

  context "Associations" do
  	it { should have_one(:address).dependent(:destroy)}
  	it { should belong_to(:contact)}

  	context "Addresss" do
  		context "from parent" do
			 	its(:address) { should eq garden.contact.address}
  		end
  		context "owns" do
  			let(:garden_own_address) { FactoryGirl.build(:garden_own_address)}
  			subject { garden_own_address }
  			its(:address) { should_not eq garden_own_address.contact.address }
  			its(:address) { should eq garden_own_address.address }
  		end
  	end
	end

end
