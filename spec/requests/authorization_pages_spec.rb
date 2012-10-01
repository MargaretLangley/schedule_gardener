require 'spec_helper'

describe "authorization" do

  let(:user) { FactoryGirl.create(:user, :client) }
  let!(:wrong_user) { FactoryGirl.create(:user, :client) }

  context "guests visiting a protected page" do
    before do
      visit edit_profile_path(user)
      visit_signin_and_login(user)
    end
    it ("forwards to the requested protected page") { current_path.should eq edit_profile_path(user) }
  end

  context "in Users controller" do

    context "client user" do
      before do
       visit_signin_and_login user
      end

      it "#index" do
        get users_path
        response.should redirect_to(root_path)
      end

      it "#edit"  do
         get edit_profile_path(user)
         response.should render_template('edit')
      end

      it "#update" do
         put update_profile_path(user)
         response.code.should == '200'
      end

      it "#delete" do
        delete user_path(user)
        response.should redirect_to(root_path)
      end

    end

    context "guests visiting protected page -> signin" do

      it "#index" do
        get users_path
        response.should redirect_to(signin_path)
      end

      it "#edit"  do
         get edit_profile_path(user)
         response.should redirect_to(signin_path)
      end

      it "#update" do
         put update_profile_path(user)
         response.should redirect_to(signin_path)
      end

      it "#delete" do
        delete user_path(user)
        response.should redirect_to(signin_path)
      end

    end

    context "wrong user action redirect to root" do
      before do
       visit_signin_and_login wrong_user
      end
      it "#show" do
        get user_path(user)
        response.should redirect_to(root_path)
      end
      it "#edit" do
        get edit_profile_path(user)
        response.should redirect_to(root_path)
      end
      it "#update" do
        put update_profile_path(user)
        response.should redirect_to(root_path)
      end
      it "#delete" do
        delete user_path(user)
        response.should redirect_to(root_path)
      end
    end
  end

  describe "in appointments controller" do
    let(:appointment) { FactoryGirl.create(:appointment, :today, contact: user.contact) }

    context "client user" do
      before do
       visit_signin_and_login user
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

end