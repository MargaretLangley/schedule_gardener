require 'spec_helper'


describe "Appointments" do

  before(:each) do
    Timecop.freeze(Time.zone.parse('1/9/2012 5:00'))
    visit_signin_and_login user
  end

  let!(:admin)        { FactoryGirl.create(:user, :admin) }
  let!(:user)         { FactoryGirl.create(:user, :client_r) }
  let!(:gardener_a)   { FactoryGirl.create(:user, :gardener_a) }
  let!(:appointment)  { FactoryGirl.create(:appointment, :tomorrow_first_slot, appointee: gardener_a.contact , contact: user.contact) }

  subject { page }

  context "#index" do
    context "standard user" do
      before(:each) { visit appointments_path }


      it ("displayed") { current_path.should eq appointments_path }
      it ("has appointee") { should have_selector('td', text: "Alan Titmarsh") }

      context "nav links" do
        it ("not displayed") { should_not have_link('This Week') }
      end

      it "edits appointment" do
        click_on('Edit')
        current_path.should eq edit_appointment_path(appointment)
      end
      it ("deletes appointment") { expect { click_on('Delete')}.to change(Appointment, :count).by(-1) }

    end

    context "gardener" do
      before do
        (FactoryGirl.create(:appointment, :next_week_first_slot, :client_a, appointee: gardener_a.contact )).save!
        visit_signin_and_login gardener_a
        visit appointments_path
      end

      it ("displayed") { current_path.should eq appointments_path }
      it ("displays phone") { should have_content('0181-100-3003')}

      context "nav links" do
        context "this week" do
          before { click_on('This Week') }
          it ("displays appointee") { should have_selector('td', text: "Roger") }
          it ("not displays next week") { should_not have_selector('td', text: "Ann") }
        end

        context "next week" do
          before { click_on('Next Week') }
          it ("displays appointee") { should have_selector('td', text: "Ann") }
          it ("not displays last week") { should_not have_selector('td', text: "Roger") }
        end
      end

      it "shows calendar" do
        click_on('Calendar')
        current_path.should eq events_path
      end

    end
  end

  context "#new" do
    before(:each) {  visit new_appointment_path }

    context "standard user" do

      it ("displayed") { current_path.should eq new_appointment_path }
      it ("has client missing") { should_not have_selector('#appointment_contact_id') }
      it "can cancel" do
        click_on("Cancel")
        current_path.should eq appointments_path
      end

      context "with valid information" do
        before { select 'Alan', from: 'appointment_appointee_id' }
        it ("adds appointment") { expect { click_on("Create Appointment") }.to change(Appointment, :count).by(1) }

        context "on create" do
          before { click_on("Create Appointment") }
          it ("displays #index") { current_path.should eq appointments_path }
          it ("flash success") { should have_flash_success ('appointment was successfully created.') }
        end

      end

      context "with invalid information" do
        before { fill_in 'Date', with: '1 Aug 2012' }

        it ("fails") { expect { click_on("Create Appointment") }.to change(Appointment, :count).by(0) }

        it "flash error" do
          click_on("Create Appointment")
          should have_content('error')
        end
      end

    end

    context "gardener" do
      before do
        visit_signin_and_login gardener_a
        visit new_appointment_path
      end

      it ("displayed") { current_path.should eq new_appointment_path }
      it ("has client") { should have_selector('#appointment_contact_id', visible: true) }

      context "with valid information" do
        before do
          select 'Alan', from: 'appointment_appointee_id'
          select 'Roger', from: 'appointment_contact_id'
        end

        it ("adds appointment") { expect { click_on("Create Appointment") }.to change(Appointment, :count).by(1) }
      end

    end

    context "admin" do
      before do
        visit_signin_and_login admin
        visit new_appointment_path
      end
      it ("displays") { current_path.should eq new_appointment_path }
    end

  end


  context "#edit" do
    before(:each) {  visit edit_appointment_path(appointment) }
    it ("displays") { current_path.should eq edit_appointment_path(appointment) }
  end

  context "#update" do
    before { visit edit_appointment_path(appointment) }

    context "with valid information" do
      before { click_on("Update Appointment") }

      context "on update" do
        it ("displays #update") { current_path.should eq appointments_path }
        it ("flash success") { should have_flash_success('appointment was successfully updated.') }
      end
    end

    context "with invalid information" do
      before do
        fill_in 'Date', with: '02 Aug 2012'
        click_on("Update Appointment")
      end
      context "on update" do
        it ("displays #update") { current_path.should eq appointment_path(appointment) }
        it ("flash error" ) { should have_content('error') }
      end
    end
  end

end





