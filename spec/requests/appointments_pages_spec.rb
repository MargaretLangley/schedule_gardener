
require 'spec_helper'

describe "Appointments" do

  before(:all) do
    @contact     = FactoryGirl.create(:contact, first_name: "Rodger", first_name: "Smith",role: :client)
    @user        = FactoryGirl.create(:user, contact: @contact)
    @appointee   = FactoryGirl.create(:contact, first_name: "Alan", last_name: "Titmarsh",role: :gardener)
    @event       = FactoryGirl.create(:event, :today, title: "appointment pages spec test")
    @appointment = Appointment.new(contact: @contact, appointee_id: @appointee.id)
    @appointment.event = @event
    @appointment.save
  end

  before(:each) do
    visit_signin_and_login @user
  end

  after(:all) do
    Appointment.delete_all;
    Event.delete_all;
    Address.delete_all;
    Contact.delete_all;
    User.delete_all;
  end

   subject { page }


  context "#index" do
    before(:each) {  visit user_appointments_path @user }

    it "open page" do
      current_path.should eq user_appointments_path @user
    end


    it "displays title" do
      should have_selector('td', text: "appointment pages spec test")
    end
    it "displays appointmee" do
      should have_selector('td', text: "Alan Titmarsh")
    end
  end

  context "#show" do
     pending
  end

  context "#new" do
    before(:each) {  visit new_user_appointment_path @user }
    it "open page" do
       current_path.should eq new_user_appointment_path(@user)
    end


    context "with valid information" do
      before do
        fill_in "Title", with: "Weeding appointment pages spec test"
        fill_in "Starts at", with: "2012-09-24 00:00"
      end
      it "add one appointment" do
        expect { click_on("Create Appointment") }.to change(Appointment, :count).by(1)
      end
      context "after creation" do
        before { click_on("Create Appointment") }
        it "displays new profile " do
          current_path.should eq user_appointments_path(@user)
        end
        it "has welcome banner" do
          should have_selector('div.alert.alert-success', text: 'appointment was successfully created.')
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


  context "#update" do
    before(:each) {  visit edit_user_appointment_path @user, @appointment }

    it "open page" do
       current_path.should eq edit_user_appointment_path(@user,@appointment)
    end

    context "verify appointment content" do

      it "have expected title" do
        should have_field 'Title', text: "appointment pages spec test"
      end
    end

    context "with valid information" do
      before do
        fill_in "Title", with: "Weeding update appointment - appointmentpages spec"
        fill_in "Starts at", with: "2012-09-30 00:00"
        click_on("Update Appointment")
      end
      context "after update" do
        it "displays new profile " do
          current_path.should eq user_appointments_path(@user)
        end
        it "has success banner" do
          should have_selector('div.alert.alert-success', text: 'appointment was successfully updated.')
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
          current_path.should eq user_appointment_path(@user,@appointment)
        end
        it "has error banner" do
          should have_content('error')
        end
      end
    end




  end

end
