# == Schema Information
#
# Table name: touches
#
#  id            :integer          not null, primary key
#  contact_id    :integer
#  by_email      :boolean
#  by_phone      :boolean
#  by_visit      :boolean
#  visit_at      :datetime
#  touch_from    :datetime
#  between_start :datetime
#  between_end   :datetime
#  completed     :boolean
#  description   :text
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'spec_helper'

describe Touch do
  before { Timecop.freeze(Time.zone.parse('1/9/2012 8:00')) }
  subject(:touch) { FactoryGirl.create(:touch, :client_r) }

  include_examples "All Built Objects", Touch

  context "Accessable" do
    [:created_at, :updated_at].each do |validate_attr|
      it { should_not allow_mass_assignment_of(validate_attr) }
    end

    [:between_end, :between_start, :by_email, :by_phone, :by_visit, :description, :touch_from, :visit_at].each do |expected_attr|
      it { should respond_to expected_attr }
    end
  end

  context "new record" do
    subject(:new_touch) { Touch.new(contact: @contact) }

    context "state" do
      it ("email not be nil") { new_touch.by_email.should_not be_nil  }
      it ("has no email")     { new_touch.by_email.should be_false  }
      it ("phone not be nil") { new_touch.by_phone.should_not be_nil  }
      it ("has no phone")     { new_touch.by_phone.should be_false  }
      it ("visit not be nil") { new_touch.by_visit.should_not be_nil  }
      it ("has no visit")     { new_touch.by_visit.should be_false  }
      it ("has visit at start of day") { new_touch.touch_from.should == 'Sat, 01 Sep 2012 00:00:00 BST +01:00'   }
      it ("has touch from today") { new_touch.touch_from.should == 'Sat, 01 Sep 2012 00:00:00 BST +01:00'   }
      it ("has between start from today") { new_touch.between_start.should == 'Sat, 01 Sep 2012 00:00:00 BST +01:00'   }
      it ("has between end in one year") { new_touch.between_end.should == 'Sat, 01 Sep 2013 00:00:00 BST +01:00'   }
      it ("has empty description") { new_touch.description.should == ''   }
      it ("completed not be nil") { new_touch.completed.should_not be_nil  }
      it ("not comploted")     { new_touch.completed.should be_false  }
      it ("be valid") { new_touch.should be_valid }
    end
  end


  context "invalid" do
    context 'when asked to make appointment' do
      context "which begins" do
        it 'before today' do
          touch.between_start = "2012/08/31"
          touch.valid?
          touch.errors[:between_start].should include('You asked for a range of appointment dates than begins before today. Please choose a start date from today.')
        end
        it 'after a year in the future' do
          touch.between_start = "2013/09/02"
          touch.valid?
          touch.errors[:between_start].should include('You asked for a range of appointment dates that starts in more than a year. Please choose an start date within a year.')
        end
      end
      context "which ends" do
        it 'after a year in the future' do
          touch.between_end = "2013/09/02"
          touch.valid?
          touch.errors[:between_end].should include('You asked for a range of appointment dates that ends in more than a year. Please choose an end date within a year.')
        end
        it "before it begins" do
          touch.between_start = "2012/09/10"
          touch.between_end = "2012/09/02"
          touch.valid?
          touch.errors[:between_end].should include('You asked for a range of appointments that end before they begin. Please choose an end date after the start date.')
        end
      end
    end
    context "when arranging an appointment" do
      it 'it is in the future' do
        touch.touch_from = "2012/08/31"
        touch.valid?
        touch.errors[:touch_from].should include('We can call you from today. Please choose a date today or in the future.')
      end
      it "it is within a year" do
        touch.touch_from = "2013/09/02"
        touch.valid?
        touch.errors[:touch_from].should include('We can call you within a year. Please choose a date within a year from today.')
      end
    end
    context "when arranging a visit" do
      it 'it is in the future' do
        touch.visit_at = "2012/08/31"
        touch.valid?
        touch.errors[:visit_at].should include('A visit must be from today. Please choose a date which is today or later.')
      end
      it "it is within a year" do
        touch.visit_at = "2013/09/02"
        touch.valid?
        touch.errors[:visit_at].should include('A visit must be arranged within a year. Please choose a date from within a year of todays date.')
      end
    end



  end


end
