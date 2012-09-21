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

    let!(:standard_user)  do
       FactoryGirl.create(:user, contact: FactoryGirl.create(:contact, first_name: user_first_name, home_phone: user_home_phone))
    end

    before do
      visit_signin_and_login admin
      visit users_path
      current_path.should eq users_path
    end

    describe "pagination" do

      before(:all)  { 30.times { FactoryGirl.create(:user) } }
      after(:all)   { User.delete_all; Contact.delete_all; Address.delete_all; }

      it "present" do
        should have_selector('div.pagination')
      end

      it "should list each user" do
        User.search_ordered.all[0..3].each do |user|
          page.should have_selector('td', text: user.full_name)
        end
      end
    end


    context "search" do
      let(:search) { 'search' }
      let(:search_button) { 'go_search' }

      before do
        page.should have_selector('td', text: admin_first_name)
        page.should have_selector('td', text: user_first_name)
      end

      context "by name" do
        before do
          fill_in(search, with: admin_first_name)
          click_button(search_button)
        end
        it "returned matches"  do
          page.should have_selector('td', text: admin_first_name)
        end

        it "left unmatched" do
          page.should_not have_selector('td', text: user_first_name)
        end
      end

      context "by phone number" do
        before do
          fill_in(search, with: admin_home_phone[2,5])
          click_button(search_button)
        end

        it "returned matches" do
          page.should have_selector('td', text: admin_first_name)
        end

        it "left unmatched" do
          page.should_not have_selector('td', text: user_first_name)
        end
      end
    end   # search

    context "User links" do

      context "edit" do

        context "for standard user" do

          it "present" do
            should have_link('edit', href: edit_user_path(standard_user))
          end
          it "edits" do
            click_on 'edit'
            current_path.should eq edit_user_path(standard_user)
          end
        end

        context "for admin user" do
          let!(:admin_edit_self) { FactoryGirl.create(:admin, contact: FactoryGirl.create(:contact, first_name: "admin_edit_self"))}
          before do
            visit users_path
          end

          it "present for self-edit" do
            should have_link('edit', href: edit_user_path(admin))
          end

          it "missing for other admin" do
            should_not have_link('edit', href: edit_user_path(admin_edit_self))
          end
        end
      end

      context "delete" do
        let!(:admin_undeleteable) { FactoryGirl.create(:admin, contact: FactoryGirl.create(:contact, first_name: "admin_undeletable")) }
        before do
          visit users_path
        end

        context "for standard user" do
          it "present" do
             should have_link('delete', href: user_path(standard_user))
          end
          it "deletes" do
            expect { click_link("delete") }.to change(User, :count).by(-1)
          end
        end

        context "for admin user" do
          it 'missing for self' do
            should_not have_link('delete', href: user_path(admin))
          end
          it 'missing for other admin' do
            should_not have_link('delete', href: user_path(admin_undeleteable))
          end
        end
      end
    end # user links

  end # index

  describe "#show " do
  	let(:user) { FactoryGirl.create(:user) }
  	before do
      visit_signin_and_login user
      visit user_path(user)
    end

    it "profile" do
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
  			it "error banner" do
          should have_content('error')
        end
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

        it "displays new profile " do
          current_path.should eq user_path(user)
        end
        it "welcome banner" do
          should have_selector('div.alert.alert-success', text: 'Welcome')
        end
        it "link to sign out" do
          should have_link('Sign out')
        end

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
      visit_signin_and_login user
      visit edit_user_path(user)
      current_path.should eq edit_user_path(user)
    end

    context "with invalid information" do
      before do
        fill_in "First name", with: ""
        click_button update_profile
      end

      it "error banner" do
        should have_content('error')
      end
    end

    context "with valid information" do
      let(:new_first_name)  { "New" }
      let(:new_last_name)  { "Name" }
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

      it "displays edited profile " do
        current_path.should eq user_path(user)
      end
      it "success banner" do
        should have_selector('div.alert.alert-success')
      end
      it "link to sign out" do
        should have_link('Sign out', href: signout_path)
      end
      it ("has expected full name") { user.reload.full_name.should eq "#{new_first_name} #{new_last_name}" }
      it ("has expected email") { user.reload.email.should eq new_email }
    end
  end
end