require 'spec_helper'

describe 'users#update' do
  let(:update_profile)      { 'Update Profile' }
  subject { page }

  let(:standard_user) do
    FactoryGirl.create(:user, contact: FactoryGirl.create(:contact, :client_j))
  end
  context 'standard user' do
    before do
      visit_signin_and_login (standard_user)
      visit edit_profile_path (standard_user)
      expect(current_path).to eq edit_profile_path(standard_user)
    end

    context 'with valid information' do
      let(:new_first_name)  { 'New' }
      let(:new_last_name)  { 'Name' }
      let(:new_email) { 'new@example.com' }
      let(:new_town) { 'New Town' }
      let(:new_phone) { '0181-999-8888' }

      before do
        fill_in 'First name',       with: new_first_name
        fill_in 'Last name',        with: new_last_name
        fill_in 'Email',            with: new_email
        fill_in 'Street number',    with: '23'
        fill_in 'Street name',      with: 'High Street'
        fill_in 'Town',             with: new_town
        fill_in 'Home phone',     with: new_phone
        click_button update_profile
      end

      it 'displays edited profile ' do
        expect(current_path).to eq edit_profile_path(standard_user)
      end
      it 'has success banner' do
        should have_flash_success('Profile update')
      end
      it 'link to sign out' do
        should have_link('Sign out', href: signout_path)
      end
      it ('has expected full name') { expect(standard_user.reload.full_name).to eq "#{new_first_name} #{new_last_name}" }
      it ('has expected email') { expect(standard_user.reload.email).to eq new_email }
    end

    context 'with invalid information' do
      before do
        fill_in 'First name', with: ''
        click_button update_profile
      end

      it 'has error banner' do
        should have_content('error')
      end
    end
  end

  context 'gardener' do
    before do
      gardener = FactoryGirl.create(:user, :gardener_a)
      # puts "gardener id" + gardener.inspect
      visit_signin_and_login gardener
      visit edit_profile_path (standard_user)
    end
    context 'on update' do
      before do
        fill_in 'Street number',    with: '99'
        click_button update_profile
      end
      it 'displays users' do
        expect(current_path).to eq users_path
      end
    end
  end
end
