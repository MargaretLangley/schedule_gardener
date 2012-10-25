require 'spec_helper'

describe "Touches" do

  before(:each) do
    Timecop.freeze(Time.zone.parse('1/9/2012 5:00'))
    @user = FactoryGirl.create(:user, :client_r)
    Capybara.reset_sessions!
    visit_signin_and_login @user
  end

  subject { page }

  context "#index" do
    context "standard user" do
      before(:each) { visit touches_path }

      it ("displayed") { current_path.should eq touches_path }
    end
  end

end