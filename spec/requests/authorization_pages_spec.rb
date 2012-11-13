require 'spec_helper'

describe "authorization" do

  before { Timecop.freeze(Time.zone.parse('1/9/2012 8:00')) }
  let(:user_j) { FactoryGirl.create(:user, :client_j) }
  let!(:wrong_user) { FactoryGirl.create(:user, :client_j) }



  context "in Users controller" do

    context "client user" do
      before do
       visit_signin_and_login user_j
      end

      it "#index" do
        get users_path
        response.should redirect_to(root_path)
      end

      it "#edit"  do
         get edit_profile_path(user_j)
         response.should render_template('edit')
      end

      it "#update" do
         put update_profile_path(user_j)
         response.code.should == '200'
      end

      it "#delete" do
        delete user_path(user_j)
        response.should redirect_to(root_path)
      end

    end

    context "guests visiting protected page -> signin" do

      it "#index" do
        get users_path
        response.should redirect_to(signin_path)
      end

      it "#edit"  do
         get edit_profile_path(user_j)
         response.should redirect_to(signin_path)
      end

      it "#update" do
         put update_profile_path(user_j)
         response.should redirect_to(signin_path)
      end

      it "#delete" do
        delete user_path(user_j)
        response.should redirect_to(signin_path)
      end

    end

    context "wrong user action redirect to root" do
      before do
       visit_signin_and_login wrong_user
      end
      it "#edit" do
        get edit_profile_path(user_j)
        response.should redirect_to(root_path)
      end
      it "#update" do
        put update_profile_path(user_j)
        response.should redirect_to(root_path)
      end
      it "#delete" do
        delete user_path(user_j)
        response.should redirect_to(root_path)
      end
    end
  end

  describe "in appointments controller" do

    let!(:appointment) { FactoryGirl.create(:appointment, :gardener_a, :today_first_slot, contact: user_j.contact ) }

    context "client user" do
      before do
       visit_signin_and_login user_j
      end

      it "#index" do
        get appointments_path
        response.code.should == '200'
      end

      it "#edit"  do
         get edit_appointment_path(appointment)
         response.code.should == '200'
      end

      it "#update" do
         put appointment_path(appointment)
         response.should redirect_to appointments_path
      end

      it "#delete" do
        delete appointment_path(appointment)
        response.should redirect_to appointments_path
      end

    end


    context "guests visiting protected page -> signin" do

      it "#index" do
        get appointments_path
        response.should redirect_to(signin_path)
      end

      it "#edit"  do
        get edit_appointment_path(appointment)
        response.should redirect_to(signin_path)
      end

      it "#update" do
        put appointment_path(appointment)
        response.should redirect_to(signin_path)
      end

      it "#delete" do
        delete appointment_path(appointment)
        response.should redirect_to(signin_path)
      end

    end

    context "wrong user action redirect to root" do
      before do
       visit_signin_and_login wrong_user
      end

      it "#edit" do
        get edit_appointment_path(appointment)
        response.should redirect_to(root_path)
      end
      it "#update" do
        put appointment_path(appointment)
        response.should redirect_to(root_path)
      end
      it "#delete" do
        delete appointment_path(appointment)
        response.should redirect_to(root_path)
      end
    end
  end

  describe "in touch controller" do

    let!(:touch) { FactoryGirl.create(:touch, contact: user_j.contact) }

    context "client user with own resources" do
      before do
       visit_signin_and_login user_j
      end

      it "#index" do
        get touches_path
        response.code.should == '200'
      end

      it "#edit"  do
         get edit_touch_path(touch)
         response.code.should == '200'
      end

      it "#update" do
         put touch_path(touch)
         response.should redirect_to touches_path
      end

      it "#delete" do
        delete touch_path(touch)
        response.should redirect_to touches_path
      end
    end

     context "guests visiting protected page -> signin" do

      it "#index" do
        get touches_path
        response.should redirect_to(signin_path)
      end

      it "#edit"  do
        get edit_touch_path(touch)
        response.should redirect_to(signin_path)
      end

      it "#update" do
        put touch_path(touch)
        response.should redirect_to(signin_path)
      end

      it "#delete" do
        delete touch_path(touch)
        response.should redirect_to(signin_path)
      end
    end

     context "wrong user action redirect to root" do
      before do
       visit_signin_and_login wrong_user
      end

      it "#edit" do
        get edit_touch_path(touch)
        response.should redirect_to(root_path)
      end
      it "#update" do
        put touch_path(touch)
        response.should redirect_to(root_path)
      end
      it "#delete" do
        delete touch_path(touch)
        response.should redirect_to(root_path)
      end
    end
  end


  describe "in dashboard controller" do

    context "client user" do
      before do
       visit_signin_and_login user_j
      end

      it "#show" do
        get dashboard_path(user_j)
        response.code.should == '200'
      end

    end


    context "guests visiting protected page -> signin" do

      it "#show" do
        get dashboard_path(user_j)
        response.should redirect_to(signin_path)
      end

    end

    context "wrong user action redirect to root" do
      before do
       visit_signin_and_login wrong_user
      end

      it "#show" do
        get dashboard_path(user_j)
        response.should redirect_to(root_path)
      end
    end
  end



  describe "events controller" do
    context "client user" do
      before do
       visit_signin_and_login user_j
      end

      it "#index" do
        get events_path
        response.code.should == '200'
      end

    end

    context "guests visiting protected page -> signin" do

      it "#index" do
        get events_path
        response.should redirect_to(signin_path)
      end

    end

  end

end