require 'spec_helper'

describe 'Contacts#index' do
  before(:each) { Timecop.freeze(Time.zone.parse('2012-9-1 5:00')) }
  subject { page }

  context 'standard user' do
    context 'displays' do
      before do
        person = FactoryGirl.create(:person,
                                    first_name: 'Ann',
                                    last_name: 'Abbey')
        visit_signin_and_login FactoryGirl.create(:user, person: person)

        FactoryGirl.create(:contact, :client_j, :tomorrow, by_phone: true)
        visit contacts_path
      end
      it ('is on page') { expect(page.title).to eq 'Garden Care | Contact Me' }
      it ('own listed') { should have_content 'Ann Abbey' }
      it ('others not listed') { should_not have_content 'John Smith' }
    end

    it 'deletes contact' do
      person = FactoryGirl.create(:person)
      user = FactoryGirl.create(:user, person: person)
      FactoryGirl.create(:contact, :tomorrow, person: user.person)

      visit_signin_and_login user
      visit contacts_path

      expect { click_on('Delete') }.to change(Contact, :count).by(-1)
    end
  end

  context 'Gardener' do
    contact = nil
    before do
      gardener = FactoryGirl
                 .create(:user, person: FactoryGirl.create(:person, :gardener_a)).person
      client = FactoryGirl
               .create(:user, person: FactoryGirl.create(:person, :client_j)).person
      visit_signin_and_login gardener.user

      contact = FactoryGirl.create(:contact, :tomorrow, person: client, appointee: gardener, by_phone: true)
      visit contacts_path
    end

    it ('displayed') { expect(page.title).to eq 'Garden Care | Contact Me' }
    it 'lists gardener and users' do
      should have_content 'Alan Titmarsh'
      should have_content 'John Smith'
    end

    it 'edits contact' do
      first(:link, 'Edit').click
      expect(current_path).to eq edit_contact_path(contact)
    end

    it 'deletes contact' do
      expect { first(:link, 'Delete').click }.to change(Contact, :count).by(-1)
    end
  end
end
