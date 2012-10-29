require 'spec_helper'

describe "Touches" do
  let(:gardener_a) { FactoryGirl.create(:user, :gardener) }
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

  context "#index" do
    before(:each) {  visit touches_path }

    context "standard user" do
      it ("displayed") { current_path.should eq touches_path }
      context "Other users" do
        before { FactoryGirl.create(:touch, :client_r, by_phone: true) }
        xit "are not listed" do
        end
      end
    end

    context "Gardenerr" do
      before do
        visit_signin_and_login gardener_a
        visit touches_path
      end

      it ("displayed") { current_path.should eq touches_path }
    end
  end

  context "#new" do
    before(:each) {  visit new_touch_path }

    context "standard user" do

      it ("displayed") { current_path.should eq new_touch_path }
      it ("has client missing") { should_not have_selector('#touch_contact_id') }
      context "hides gardener only contnet" do
        it ("by phone")  { should_not have_content'By phone' }
        it ("by visit")  { should_not have_content'By visit' }
        it ("completed")  { should_not have_content'Completed' }
      end

      context "with valid information" do

        it ("adds touch") { expect { click_on("Contact Me") }.to change(Touch, :count).by(1) }

        context "on create" do
          before { click_on("Contact Me") }
          it ("displays #index") { current_path.should eq touches_path }
          it ("flash success") { should have_flash_success ('Contact me was successfully created.') }
        end

      end

      context "with invalid information" do
        before do
          fill_in 'Contact from', with: '1 Aug 2012'
        end

        it ("fails") { expect { click_on("Contact Me") }.to change(Touch, :count).by(0) }

        it "flash error" do
          click_on("Contact Me")
          should have_content('error')
        end
      end
    end

    context "gardener" do
      before do
        visit_signin_and_login gardener_a
        visit new_touch_path
      end

      context "has gardener only contnet" do
        it ("by phone")  { should have_content'By phone' }
        it ("by visit")  { should have_content'By visit' }
        it ("completed")  { should have_content'Completed' }
      end

       context "with valid information" do
        before { check 'By phone' }
        it ("adds touch") { expect { click_on("Contact Me") }.to change(Touch, :count).by(1) }
      end
    end

  end
end
