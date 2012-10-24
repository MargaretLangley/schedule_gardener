
require 'spec_helper'

describe "Appointments" do

  before(:all) do
    @admin        = FactoryGirl.create(:user, :admin)
    @user         = FactoryGirl.create(:user, :client_r)
    @gardener     = FactoryGirl.create(:user, :gardener)
  end

  before(:each) do
    Timecop.freeze(Time.zone.parse('1/9/2012 5:00'))
    (@appointment = FactoryGirl.create(:appointment, :gardener_a, :tomorrow_first_slot, contact: @user.contact)).save!
    (FactoryGirl.create(:appointment, :gardener_p, :next_week_first_slot, contact: @user.contact)).save!
    Capybara.reset_sessions!
    visit_signin_and_login @user
  end

  after(:all) do
    Address.delete_all;
    Contact.delete_all;
    User.delete_all;
  end

  subject { page }

  context "#index" do
    before(:each) do
      visit appointments_path
    end

    it "open page" do
      current_path.should eq appointments_path
    end

    it "displays appointee" do
      should have_selector('td', text: "Alan Titmarsh")
    end
    it "edits appointments" do
      click_on('Edit')
      current_path.should eq edit_appointment_path(@appointment)
    end
    it "deletes appointments" do
      expect { click_on('Delete')}.to change(Appointment, :count).by(-1)
    end
    it "shows calendar" do
      click_on('Calendar')
      current_path.should eq events_path
    end
    context "this week" do
      before do
        click_on('This Week')
      end
      it "displays appointee" do
        should have_selector('td', text: "Alan Titmarsh")
      end
    end
    context "next week" do
      before do
        click_on('Next Week')
      end
      it "displays appointee" do
        should have_selector('td', text: "Percy Thrower")
      end
    end

  end

  context "#new" do
    before(:each) {  visit new_appointment_path }
    it "open page" do
       current_path.should eq new_appointment_path
    end

    context "standard user" do

      context "with valid information" do
        before do
          select 'Alan', from: 'appointment_appointee_id'
        end
        it "has client missing" do
          should_not have_selector('#appointment_contact_id')
        end

        it "add one appointment" do
          expect { click_on("Create Appointment") }.to change(Appointment, :count).by(1)
        end
        context "after creation" do
          before { click_on("Create Appointment") }
          it "displays new profile " do
            current_path.should eq appointments_path
          end
          it "has welcome banner" do
            should have_flash_success ('appointment was successfully created.')
          end
        end

      end

      context "with invalid information" do
        before "does not add an appointment" do
          fill_in 'Date', with: '1 Aug 2012'
        end

        it "fails" do
          expect { click_on("Create Appointment") }.to change(Appointment, :count).by(0)
        end

        it "has error banner" do
          click_on("Create Appointment")
          should have_content('error')
        end
      end

    end

    context "gardener" do
      before do
       visit_signin_and_login @gardener
       visit new_appointment_path
      end

      it "open page" do
        current_path.should eq new_appointment_path
      end

      it "has client" do
        should have_selector('#appointment_contact_id', visible: true)
      end

      context "with valid information" do
        before do
          select 'Alan', from: 'appointment_appointee_id'
          select 'Roger', from: 'appointment_contact_id'
        end

        it "add one appointment" do
          expect { click_on("Create Appointment") }.to change(Appointment, :count).by(1)
        end
      end

    end

    context "admin" do
      before do
        visit_signin_and_login @admin
        visit new_appointment_path
      end

      it "open page" do
        current_path.should eq new_appointment_path
      end
    end

  end


  context "#edit" do
    before(:each) {  visit edit_appointment_path(@appointment) }

    it "open page" do
       current_path.should eq edit_appointment_path(@appointment)
    end
  end

  context "#update" do
    before do
      visit edit_appointment_path(@appointment)
    end


    context "with valid information" do
      before do
        click_on("Update Appointment")
      end
      context "after update" do
        it "displays new profile " do
          current_path.should eq appointments_path
        end
        it "has success banner" do
          should have_flash_success('appointment was successfully updated.')
        end
      end
    end

    context "with invalid information" do
      before do
        fill_in 'appointment_starts_at_date', with: '02 Aug 2012'
        click_on("Update Appointment")
      end
      context "after update" do
        it "displays edit profile " do
          current_path.should eq appointment_path(@appointment)
        end
        it "has error banner" do
          should have_content('error')
        end
      end
    end
  end


end





