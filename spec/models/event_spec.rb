
require 'spec_helper'
include ActionView::Helpers::DateHelper
require 'active_support/core_ext/time/calculations'


describe Event do
  subject(:event) { FactoryGirl.build(:event)}
  include_examples "All Built Objects", Event

  context "Accessable" do

		[ :created_at, :updated_at].each do |validate_attr|
			it { should_not allow_mass_assignment_of(validate_attr) }
		end

	 [:all_day, :description, :ends_at, :starts_at, :title ].each do |expected_attr|
			it { should respond_to expected_attr }
		end
	end

	context "Validations" do

		[ :starts_at, :title ].each do |validate_attr|
			it { should validate_presence_of(validate_attr) }
		end

		[ :title ].each do |validate_attr|
			it { should ensure_length_of(validate_attr).is_at_most(50) }
		end

	end

	 context "Custom finders" do

	   context "#within_date_range" do
	 		
	 		context "on boundary" do
	 		  e1 = e2 = e3 = e4 = nil
	 		  before(:all) do
		 			e1 = FactoryGirl.create(:event, title: "e0", starts_at: Time.now.utc.beginning_of_month.advance(hours: -4))	 		
		 			e2 = FactoryGirl.create(:event, title: "e2", starts_at: Time.now.utc.beginning_of_month.advance(hours: 1))
		 			e3 = FactoryGirl.create(:event, title: "e3", starts_at: Time.now.utc.end_of_month.advance(hours: -4))
		 			e4 = FactoryGirl.create(:event, title: "e3", starts_at: Time.now.utc.end_of_month.advance(hours: 4))
		 			Event.all.should eq [e1, e2,e3,e4]
		 		end
		    after(:all) { Event.destroy_all}

		    it "suceeds" do
			    Event.within_date_range(Time.now.utc.beginning_of_month,
			    	                 			Time.now.utc.end_of_month,
			    	                 			).should eq [e2,e3]
		    end
		  end 

		  context "accross boundary" do
			  e1 = e2 = nil
	 		  before(:all) do
	 		  	e1 = FactoryGirl.create(:event, title: "e1", starts_at: Time.now.utc.beginning_of_month.advance(hours: -2))
	 			  e2 = FactoryGirl.create(:event, title: "e2", starts_at: Time.now.utc.end_of_month.advance(hours: - 1))

		 			Event.all.should eq [e1, e2]
		 		end
		    after(:all) { Event.destroy_all}

		    it "suceeds" do
			    Event.within_date_range(Time.now.utc.beginning_of_month,
			    	                 		 Time.now.utc.end_of_month,
			    	                 		 ).should eq [e1,e2]
		    end
      end

		  context "nil end" do
			  e1 = e2 = nil
	 		  before(:all) do
	 		  	e1 = FactoryGirl.create(:event, title: "e1", ends_at: nil, starts_at: Time.now.utc.beginning_of_month.advance(hours: + 10))
		 			Event.all.should eq [e1]
		 		end
		    after(:all) { Event.destroy_all}

		    it "suceeds" do
			    Event.within_date_range(Time.now.utc.beginning_of_month,
			    	              	  	 Time.now.utc.end_of_month,
			    	                	 	 ).should eq [e1]
		    end
      end


    end
	 		
    

	 end



	describe "Association" do

		xit "to do"
     
	end
end
