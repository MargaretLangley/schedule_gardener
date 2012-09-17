require 'spec_helper'

describe "users" do

  subject { page }

  let(:update_profile)      { "Update Profile" }
  let(:admin_first_name)    { "bob_admin" }
  let(:user_first_name)     { "alice_user" }
  let(:user_home_phone)   { "0123456789" }
  let(:admin_home_phone)   { "44884488" }

  context "#index" do
    # Need constants but don't know which is best way in RSpec
    let(:users)   { "Users" }

    let!(:admin)  do
      FactoryGirl.create(:admin, contact: FactoryGirl.create(:contact, first_name: admin_first_name, home_phone: admin_home_phone))
    end

    let!(:none_admin_user)  do
       FactoryGirl.create(:user, contact: FactoryGirl.create(:contact, first_name: user_first_name, home_phone: user_home_phone))
    end

    before do
      sign_in admin
      visit users_path
    end

    context "view" do
      it "should see users list" do
        current_path.should eq users_path
      end
    end

    describe "pagination" do

      before(:all)  { 30.times { FactoryGirl.create(:user) } }
      after(:all)   { User.delete_all; Contact.delete_all; Address.delete_all; }

      let(:first_page)  { User.paginate(page: 1) }
      let(:second_page) { User.paginate(page: 2) }

      it { should have_selector('div.pagination') }

      it "should list each user" do
        User.search_ordered.all[0..3].each do |user|
          page.should have_selector('td', text: user.first_name)
        end
      end
    end

    context "search" do
      let(:search) { 'search' }
      let(:search_button) { 'go_search' }

      it "sanity test"  do
        page.should have_selector('td', text: admin_first_name)
        page.should have_selector('td', text: user_first_name)
      end

      context "by name" do
        before do
          fill_in(search, with: admin_first_name)
          click_button(search_button)
        end
        it "should return matched searched name"  do
          page.should have_selector('td', text: admin_first_name)
        end

        it "should not return unmatched searched name" do
          page.should_not have_selector('td', text: user_first_name)
        end
      end

      context "by number" do
        before do
          fill_in(search, with: admin_home_phone[2,5])
          click_button(search_button)
        end

        it "should return user with home phone number" do
          page.should have_selector('td', text: admin_first_name)
        end

        it "should not return user without home phone number" do
          page.should_not have_selector('td', text: user_first_name)
        end
      end
    end   # search

    context "User links" do

      context "for none-admin user" do

        it "should include edit link" do
          should have_link('edit', href: edit_user_path(none_admin_user))
        end
        context "which is valid" do
          before { click_on 'edit'}
          it "and reach the users edit page" do
            current_path.should eq edit_user_path(none_admin_user)
          end
        end
      end

      context "for admin user" do
        let!(:admin_edit_self) { FactoryGirl.create(:admin, contact: FactoryGirl.create(:contact, first_name: "admin_edit_self"))}
        before do
          visit users_path
        end

        it "should edit self" do
          should have_link('edit', href: edit_user_path(admin))
        end

        it "should not edit another admin" do
          should_not have_link('edit', href: edit_user_path(admin_edit_self))
        end
      end

      context "#delete" do
        let!(:admin_undeleteable) { FactoryGirl.create(:admin, contact: FactoryGirl.create(:contact, first_name: "admin_undeletable")) }
        before do
          visit users_path
        end

        it { should have_link('delete', href: user_path(none_admin_user))}
        it "should be able to delete another user" do
          expect { click_link("delete") }.to change(User, :count).by(-1)
        end
        it 'should not delete self' do
          should_not have_link('delete', href: user_path(admin))
        end
        it 'should not delete another admin' do
          should_not have_link('delete', href: user_path(admin_undeleteable))
        end
      end
    end # user links

    # sign in with one user and Create two other users
    context "None-admin users" do
      it "should be sent to root" do
        sign_in FactoryGirl.create(:user)
        visit users_path
        current_path.should eq root_path
      end
    end
  end # index

  describe "#show profile page" do
  	let(:user) { FactoryGirl.create(:user) }
  	before do
      sign_in user
     visit user_path(user)
    end

    it "should open user_path page" do
      current_path.should eq user_path(user)
    end
  end

  describe "signup page" do
    before { visit signup_path }
    it { current_path.should eq signup_path }
  end


  describe "signup" do
  	before { visit signup_path }

  	let(:submit) { "Create my account" }

  	describe "with invalid information" do
  		it "should not create a user" do
  			expect { click_button submit }.not_to change(User, :count)
  		end

  		describe "after submission" do
  			before { click_button submit }

        it {  current_path.should eq signup_path  }
  			it { should have_content('error')}
  		end
  	end

  	describe "with valid information" do
  		before do
  			fill_in "First name",				with: "Example"
  			fill_in "Last name",				with: "User"
  			fill_in "Email",						with: "user@example.com"
  			fill_in	"Password",					with: "foobar"
  			fill_in "Confirm password",	with: "foobar"
  			fill_in "Street number",		with: "23"
        fill_in "Street name",      with: "High Street"
  			fill_in "Town",							with: "Stratford"
  			fill_in "Home phone",			  with: "0181-333-4444"
  		end

  		it "should create a user" do
  			expect { click_button submit }.to change(User, :count).by(1)
  		end

  		describe "after saving the user" do
        before { click_button submit }
        let(:user) { User.find_by_email('user@example.com') }

        it { should have_selector('title', text: "Profile") }
        it { should have_selector('div.alert.alert-success', text: 'Welcome') }
        it { should have_link('Sign out')}

        context "followed by signout" do
          before { click_link "Sign out" }
          it { should have_link('Sign in')}
        end
      end
  	end
  end

  context "#edit" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      sign_in user
      visit edit_user_path(user)
    end

    context "page" do
      it { current_path.should eq edit_user_path(user) }
    end

    describe "with invalid information" do
      before do
        fill_in "First name", with: ""
        click_button update_profile
      end

      it { should have_content('error') }
    end

    describe "with valid information" do
      let(:new_first_name)  { "New first Name" }
      let(:new_last_name)  { "New last Name" }
      let(:new_email) { "new@example.com" }
      let(:new_town) { "New Town" }
      let(:new_phone) { "0181-999-8888" }

      before do
        fill_in "First name",       with: new_first_name
        fill_in "Last name",        with: new_last_name
        fill_in "Email",            with: new_email
        fill_in "Street number",    with: "23"
        fill_in "Street name",      with: "High Street"
        fill_in "Town",             with: new_town
        fill_in "Home phone",     with: new_phone
        click_button update_profile
      end

      it { should have_selector('title', text: "Profile") }
      it { should have_selector('div.alert.alert-success') }
      it { should have_link('Sign out', href: signout_path) }
      specify { user.reload.first_name.should  eq new_first_name }
      specify { user.reload.email.should eq new_email }
    end
  end
end