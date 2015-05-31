require 'spec_helper'

describe 'Contacts#update' do
  before(:each) do
    Timecop.freeze(Time.zone.parse('2012-9-1 5:00'))
    visit_signin_and_login user
  end

  context 'as client' do
    let(:user) do
      FactoryGirl.create(:user, person: FactoryGirl.create(:person, :client_r))
    end

    subject { page }

    it 'displays' do
      contact = FactoryGirl.create(:contact, :tomorrow, person: user.person)
      visit edit_contact_path(contact)

      expect(current_path).to eq edit_contact_path(contact)
    end

    context 'with valid update' do
      before do
        contact = FactoryGirl.create(:contact, :tomorrow, person: user.person)
        visit edit_contact_path(contact)
        click_on('Update Contact Me')
      end

      it ('displays #index') { expect(current_path).to eq contacts_path }
      it 'flashes success' do
        should have_flash_success('Contact me was successfully updated.')
      end
    end

    # client - not thought of way to error on contact update
  end

  context 'as gardener' do
    let(:user) do
      FactoryGirl.create(:user, person: FactoryGirl.create(:person, :gardener_a))
    end

    subject { page }

    context 'invalid information' do
      it 'errors' do
        contact = FactoryGirl.create(:contact, :tomorrow, person: user.person)
        visit edit_contact_path(contact)

        fill_in 'Contact from', with: '1 Aug 2012'
        uncheck 'By phone'
        click_on('Contact Me')

        should have_content('error')
      end
    end
  end
end
