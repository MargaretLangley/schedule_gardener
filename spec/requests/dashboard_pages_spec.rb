require 'spec_helper'

describe "Dashboard#show" do

    context "standard user" do
      let!(:user_r) { FactoryGirl.create(:user, :client_r) }
      before do
        visit_signin_and_login user_r
        visit dashboard_path(user_r)
      end
      it ("displayed") { current_path.should eq dashboard_path(user_r) }
    end

    context "Gardenerr" do
      let(:gardener_a) { FactoryGirl.create(:user, :gardener) }
      before do
        visit_signin_and_login gardener_a
        visit dashboard_path(gardener_a)
      end

      it ("displayed") { current_path.should eq dashboard_path(gardener_a) }
    end

end