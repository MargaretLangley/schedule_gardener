require 'spec_helper'

describe 'Authentication' do
  let(:user) do
    FactoryGirl.create(:user, contact: FactoryGirl.create(:contact, :client_j))
  end
  let(:gardener) do
    FactoryGirl.create :user, contact: FactoryGirl.create(:contact, :gardener_a)
  end
  let(:admin) { FactoryGirl.create(:user, :admin) }

  subject { page }

  describe 'visit sign_in page' do
    it 'remains on sign_in' do
      visit signin_path
      expect(current_path).to eq signin_path
    end

    it 'has forgotten password link' do
      visit signin_path
      should have_link('forgotten password?', href: new_password_reset_path)
    end

    describe 'sign_in' do
      before  do
        visit signin_path
      end
      context 'succeeds' do
        context 'for standard user' do
          before { login_user(user) }

          it ('opens start page') { expect(current_path).to eq dashboard_path(user) }
          it ("has 'full name' link")      { should have_link('John Smith',  href: '#') }
          it ("has 'Update Profile' link") { should have_link('Update Profile', href: edit_profile_path(user)) }
          it ("has 'Sign out' link ")      { should have_link('Sign out',      href: signout_path) }

          context 'can sign out' do
            before { click_link 'Sign out' }
            it ('redirects to root') { expect(current_path).to eq root_path }
            it ("has no 'full name' link")      { should_not have_link(user.full_name,   href: '#') }
            it ("has no 'Update Profile' link") { should_not have_link('Update Profile', href: edit_profile_path(user)) }
            it ("has no 'Sign out' link")       { should_not have_link('Sign out',       href: signout_path) }
          end
        end

        context 'for gardener' do
          before { login_user(gardener) }

          it ('opens start page')      { expect(current_path).to eq dashboard_path(gardener) }
          it ("has 'full name' link")      { should have_link('Alan Titmarsh', href: '#') }
          it ("has 'Update Profile' link") { should have_link('Update Profile', href: edit_profile_path(gardener)) }
          it ("has 'Sign out' link ")      { should have_link('Sign out',      href: signout_path) }
        end

        context 'for admin user' do
          before { login_user(admin) }

          it ('opens start page')      { expect(current_path).to eq dashboard_path(admin) }
        end
      end

      context 'fails' do
        before { fail_login_user }

        it ('remains on sign_in page')      { expect(current_path).to eq signin_path }
        it ('has error banner')             { should have_flash_error('Invalid') }
        it ("has no 'full name' link")      { should_not have_link(user.full_name,   href: '#') }
        it ("has no 'Update Profile' link") { should_not have_link('Update Profile', href: edit_profile_path(user)) }
        it ("has no 'Sign out' link")       { should_not have_link('Sign out',       href: signout_path) }
      end
    end
  end # visit sign_in page

  context 'guests visits a protected page without sign_in' do
    it 'forwards to the requested (protected) start page' do
      visit edit_profile_path(user)
      visit_signin_and_login(user)

      expect(current_path).to eq edit_profile_path(user)
    end
  end
end
