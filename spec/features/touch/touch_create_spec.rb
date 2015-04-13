require 'spec_helper'

describe 'Touches#create' do
  before(:each) { Timecop.freeze(Time.zone.parse('2012-9-1 5:00')) }
  subject { page }

  context 'standard user' do
    let(:user_r) { FactoryGirl.create(:user, :client_r) }
    before(:each) do
      visit_signin_and_login user_r
      visit new_touch_path
    end

    it ('displayed') { expect(current_path).to eq new_touch_path }
    it ('has client missing') { should_not have_selector('#touch_contact_id') }
    it 'can cancel' do
      click_on('Cancel')
      expect(current_path).to eq touches_path
    end

    context 'hides gardener only content' do
      it ('by phone')  { should_not have_content 'By phone' }
      it ('by visit')  { should_not have_content 'By visit' }
      it ('completed') { should_not have_content 'Completed' }
    end

    context 'with valid information' do
      it 'adds touch' do
        fill_in 'Contact from', with: '1 Oct 2012'

        expect { click_on('Contact Me') }.to change(Touch, :count).by(1)
      end

      context 'on create' do
        it ('displays #index') do
          click_on('Contact Me')

          expect(current_path).to eq touches_path
        end
        it 'flash success' do
          fill_in 'Contact from', with: '1 Oct 2012'
          click_on('Contact Me')

          should have_flash_success ('Contact me was successfully created.')
        end
      end
    end

    context 'with invalid information' do
      it 'fails' do
        fill_in 'Contact from', with: '1 Aug 2012'

        expect { click_on('Contact Me') }.to change(Touch, :count).by(0)
      end

      it 'flash error' do
        fill_in 'Contact from', with: '1 Aug 2012'
        click_on('Contact Me')

        should have_content('error')
      end
    end
  end

  context 'gardener' do
    let(:gardener_a) { FactoryGirl.create(:user, :gardener_a) }
    before do
      visit_signin_and_login gardener_a
      visit new_touch_path
    end

    describe 'has gardener only content' do
      it ('by phone')  { should have_content 'By phone' }
      it ('by visit')  { should have_content 'By visit' }
      it ('completed') { should have_content 'Completed' }
    end

    context 'with valid information' do
      it 'adds touch' do
        fill_in 'Contact from', with: '1 Oct 2012'
        check 'By phone'

        expect { click_on('Contact Me') }.to change(Touch, :count).by(1)
      end
    end
  end
end
