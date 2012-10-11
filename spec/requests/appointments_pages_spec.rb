
require 'spec_helper'

describe "Appointments" do

  before(:all) do
    @user        = FactoryGirl.create(:user, contact: FactoryGirl.build(:contact, first_name: "Rodger", last_name: "Smith",role: :client))
  end

  before(:each) do
    @appointment = FactoryGirl.create(:appointment, :tomorrow, contact: @user.contact, title: "appointment pages spec test")
  end

  after(:all) do
    Address.delete_all;
    Contact.delete_all;
    User.delete_all;
  end

  before(:each) do
    visit_signin_and_login @user
  end

  subject { page }

  context "#index" do
    before(:each) { visit appointments_path }

    it "open page" do
      current_path.should eq appointments_path
    end

    it "displays title" do
      should have_selector('td', text: "appointment pages spec test")
    end

    it "displays appointmee" do
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
          fill_in "Title", with: "Weeding appointment pages spec test"
          fill_in "Starts at", with: "2012-09-24 00:00"
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
        it "does not add an appointment" do
          expect { click_on("Create Appointment") }.to change(Appointment, :count).by(0)
        end

         it "has error banner" do
          click_on("Create Appointment")
          should have_content('error')
        end
      end

    end

    context "admin" do

      before do
        #@admin = FactoryGirl.create(:user, :admin)

        # visit_signin_and_login @admin
        # select 'Rodger', from: 'appointment_contact_id'
        # select 'Alan', from: 'appointment_appointee_id'
        # fill_in "Title", with: "Weeding appointment pages spec test"
        # fill_in "Starts at", with: "2012-09-24 00:00"
      end
      it "add one appointment" do
        pending #expect { click_on("Create Appointment") }.to change(Appointment, :count).by(1)
      end
    end

  end


  context "#edit" do
    before(:each) {  visit edit_appointment_path(@appointment) }

    it "open page" do
       current_path.should eq edit_appointment_path(@appointment)
    end

    context "verify appointment content" do

      it "have expected title" do
        should have_field 'Title', text: "appointment pages spec test"
      end
    end
  end

  context "#update" do
    before do
      visit edit_appointment_path(@appointment)
    end


    context "with valid information" do
      before do
        fill_in "Title", with: "Weeding update appointment - appointmentpages spec"
        fill_in "Starts at", with: "2012-09-30 00:00"
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
        fill_in "Title", with: ""
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
