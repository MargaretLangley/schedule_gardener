require 'spec_helper'

describe 'Touches#update' do
  before(:each) do
    Timecop.freeze(Time.zone.parse('2012-9-1 5:00'))
    visit_signin_and_login user
  end

  context 'as client' do
    let(:user) do
      FactoryGirl.create(:user, contact: FactoryGirl.create(:contact, :client_r))
    end

    subject { page }

    it 'displays' do
      touch = FactoryGirl.create(:touch, :tomorrow, contact: user.contact)
      visit edit_touch_path(touch)

      expect(current_path).to eq edit_touch_path(touch)
    end

    context 'with valid update' do
      before do
        touch = FactoryGirl.create(:touch, :tomorrow, contact: user.contact)
        visit edit_touch_path(touch)
        click_on('Update Contact Me')
      end

      it ('displays #index') { expect(current_path).to eq touches_path }
      it 'flashes success' do
        should have_flash_success('Contact me was successfully updated.')
      end
    end

    # client - not thought of way to error on touch update
  end

  context 'as gardener' do
    let(:user) do
      FactoryGirl.create(:user, contact: FactoryGirl.create(:contact, :gardener_a))
    end

    subject { page }

    context 'invalid information' do
      it 'errors' do
        touch = FactoryGirl.create(:touch, :tomorrow, contact: user.contact)
        visit edit_touch_path(touch)

        fill_in 'Contact from', with: '1 Aug 2012'
        uncheck 'By phone'
        click_on('Contact Me')

        should have_content('error')
      end
    end
  end
end
