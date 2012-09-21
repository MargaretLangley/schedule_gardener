require 'spec_helper'

describe "authorization" do

  let(:user) { FactoryGirl.create(:user) }


  describe "for signed out user" do
    let(:appointment) { FactoryGirl.create(:appointment, :today) }

    context "visit a protected page" do
      before do
        visit edit_user_path(user)
        visit_signin_and_login(user)
      end
      it ("forwards to the requested protected page") { current_path.should eq edit_user_path(user) }
    end

    context "in the Users controller" do

      describe "visiting a protected page" do

        it "#index redirect to sign in page" do
          visit users_path
          current_path.should eq signin_path
        end

        it "#edit  redirect to sign in page"  do
           visit edit_user_path(user)
           current_path.should eq signin_path
        end

        context "submitting to the update action" do
          before { put user_path(user) }
          it ("should redirect to sign in page") { response.should redirect_to(signin_path) }
        end
      end
    end

    describe "in the appointments controller" do
      let!(:wrong_user) { FactoryGirl.create(:user) }

      describe "visiting the user appointments index " do
        before { visit user_appointments_path(user)  }
        it { current_path.should eq signin_path  }
      end

      describe "submitting to the update action" do
        before { put user_appointment_path(user, appointment) }
        it { response.should redirect_to(signin_path) }
      end

      describe "wrong user accessing appointments" do
        before do
         #  puts appointment.inspect
         #  puts wrong_user.inspect
         # sign_in wrong_user
         # visit edit_user_appointment_path(wrong_user, appointment)
        end
        #it { current_path.should eq root_path }
        pending
      end
    end

  end

  context "redirect to root" do
    before { visit_signin_and_login user }

    describe "as wrong user" do
      let(:wrong_user) { FactoryGirl.create(:user) }

      it "when visiting Users#show page" do
        visit user_path(wrong_user)
        current_path.should eq root_path
      end

      it "when visiting Users#edit page" do
        visit edit_user_path(wrong_user)
        current_path.should eq root_path
      end

      it "when submitting a PUT request to the Users#update action" do
        # put user_path(wrong_user)
        # response.should redirect_to(root_path)
        pending "wait for authorization gem can can"
      end

    end

    context "for standard user" do

      it "when submitting a DELETE request to the Users#destroy action" do
        # delete user_path(user)
        # response.should redirect_to(root_path)
        pending "wait for authorization gem can can"
      end

      it "visiting users index are sent to root" do

        visit users_path
        current_path.should eq root_path
      end

    end
  end

end