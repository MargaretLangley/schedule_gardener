
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


    it "displays title" do
      should have_selector('td', text: "appointment pages spec test")
    end
    it "displays appointmee" do
      should have_selector('td', text: "Alan Titmarsh")
    end
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

    end

    context "with invalid information" do
      pending
    end

  end

  context "#show" do
     pending
  end


  context "#update" do
    pending
  end

end
