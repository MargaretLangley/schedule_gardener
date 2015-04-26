require 'spec_helper'

describe 'users#create' do
  subject { page }

  context 'standard user' do
    before do
      visit signup_path
      expect(current_path).to eq signup_path
    end

    let(:submit) { 'Create account' }

    context 'with valid information' do
      before do
        fill_in 'First name',       with: 'Example'
        fill_in 'Last name',        with: 'User'
        fill_in 'Email',            with: 'user@example.com'
        fill_in 'Password',         with: 'foobar'
        fill_in 'Confirm password', with: 'foobar'
        fill_in 'Street number',    with: '23'
        fill_in 'Street name',      with: 'High Street'
        fill_in 'Town',             with: 'Stratford'
        fill_in 'Home phone',       with: '0181-333-4444'
      end

      it 'should create a user' do
        expect { click_button submit }.to change(User, :count).by(1)
      end

      context 'after saving the user' do
        before { click_button submit }
        let(:user) { User.find_by_email('user@example.com') }

        it 'displays new profile ' do
          expect(current_path).to eq dashboard_path(user)
        end
        it  { should have_flash_success('Welcome') }

        it 'link to sign out' do
          should have_link('Sign out')
        end

        context 'followed by signout' do
          before { click_link 'Sign out' }
          it { should have_link('Sign in') }
        end
      end
    end

    context 'with invalid information' do
      it 'should not create a user' do
        expect { click_button submit }.not_to change(User, :count)
      end

      describe 'after submission' do
        before { click_button submit }

        it ('remains on signup url') {  expect(current_path).to eq signup_path  }
        it 'has error banner' do
          should have_content('error')
        end
      end
    end
  end

  context 'gardener with valid information' do
    before do
      gardener =
        FactoryGirl
        .create(:user, contact: FactoryGirl.create(:contact, :gardener_a))
      visit_signin_and_login gardener
      visit signup_path

      fill_in 'First name',       with: 'Example'
      fill_in 'Last name',        with: 'Example'
      fill_in 'Email',            with: 'user@example.com'
      fill_in 'Password',         with: 'foobar'
      fill_in 'Confirm password', with: 'foobar'
      fill_in 'Street number',    with: '23'
      fill_in 'Street name',      with: 'High Street'
      fill_in 'Town',             with: 'Stratford'
      fill_in 'Home phone',       with: '0181-333-4444'
    end

    it 'should create a user' do
      expect { click_button 'Create account' }.to change(User, :count).by(1)
    end

    context 'after saving the user' do
      before { click_button 'Create account' }

      it 'back to users' do
        expect(current_path).to eq users_path
      end
      it  { should have_flash_success('New User Created') }
    end
  end
end
