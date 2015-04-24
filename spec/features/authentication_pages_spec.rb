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

  context 'visit sigin page' do
    before  do
      visit signin_path
    end

    it 'remains on signin' do
      expect(current_path).to eq signin_path
    end

    context 'visible' do
      it ('has forgotten password link')   { should have_link('forgotten password?', href: new_password_reset_path) }
    end

    context 'signin' do
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

          xit ('opens start page')      { expect(current_path).to eq dashboard_path(admin) }
        end
      end

      context 'fails for all-users' do
        before { click_button 'Sign in' }

        it ('remains on signin page')       { expect(current_path).to eq signin_path }
        it ('has error banner')             { should have_flash_error('Invalid') }
        it ("has no 'full name' link")      { should_not have_link(user.full_name,   href: '#') }
        it ("has no 'Update Profile' link") { should_not have_link('Update Profile', href: edit_profile_path(user)) }
        it ("has no 'Sign out' link")       { should_not have_link('Sign out',       href: signout_path) }

        describe 'after visiting another page' do
          before { click_link 'logo' }
          it ('has no error banner') { should_not have_content('Invalid') }
        end
      end

      context 'admin area' do
        it 'redirected to signin path' do
          visit rails_admin_path

          expect(current_path).to eq signin_path
        end

        it 'redirects admin user to signin path' do
          visit rails_admin_path
          login_user(admin)

          expect(current_path).to eq rails_admin_path + '/'
        end

        context 'for standard user' do
          it 'redirected to root path' do
            visit rails_admin_path
            login_user(user)

            expect(current_path).to eq root_path
          end
        end
      end
    end
  end # visit signin page

  context 'guests visits a protected page without signin' do
    it 'forwards to the requested (protected) start page' do
      visit edit_profile_path(user)
      visit_signin_and_login(user)

      expect(current_path).to eq edit_profile_path(user)
    end
  end
end
