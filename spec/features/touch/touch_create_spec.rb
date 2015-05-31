require 'spec_helper'

describe 'Touches#create' do
  before(:each) { Timecop.freeze(Time.zone.parse('2012-9-1 5:00')) }
  subject { page }

  context 'standard user' do
    let(:user_r) do
      FactoryGirl.create(:user, person: FactoryGirl.create(:person, :client_r))
    end
    let!(:gardener_alan) do
      gardener = FactoryGirl.create(:person, :gardener_a)
      FactoryGirl.create(:user, person: gardener)
    end

    before(:each) do
      visit_signin_and_login user_r
      visit new_touch_path
    end

    it ('displayed') { expect(current_path).to eq new_touch_path }
    it 'can cancel' do
      click_on('Cancel')
      expect(current_path).to eq touches_path
    end

    describe 'hides gardener only content' do
      it ('has client missing') { should_not have_content('Client') }
      it ('by phone')  { should_not have_content 'By phone' }
      it ('by visit')  { should_not have_content 'By visit' }
      it ('completed') { should_not have_content 'Completed' }
    end

    context 'with valid information' do
      it 'adds touch' do
        select 'Alan', from: 'Gardener'
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
    let(:gardener_a) do
      FactoryGirl.create(:user,
                         person: FactoryGirl.create(:person, :gardener_a))
    end

    describe 'has gardener only content' do
      before do
        visit_signin_and_login gardener_a
        visit new_touch_path
      end
      it ('has client') { should have_content('Client') }
      it ('by phone')  { should have_content 'By phone' }
      it ('by visit')  { should have_content 'By visit' }
      it ('completed') { should have_content 'Completed' }
    end

    it 'with valid information it adds touch' do
      FactoryGirl.create(:person, :client_a)
      visit_signin_and_login gardener_a
      visit new_touch_path

      select('Ann', from: 'Client') # Explicit but works anyway
      fill_in 'Contact from', with: '1 Oct 2012'
      check 'By phone'
      expect { click_on('Contact Me') }.to change(Touch, :count).by(1)
    end
  end
end
