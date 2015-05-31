require 'spec_helper'

describe 'users#index' do
  let(:admin_first_name)    { 'bob_admin' }
  let(:user_first_name)     { 'alice_user' }
  let(:user_home_phone)   { '0123456789' }
  let(:admin_home_phone)   { '44884488' }

  subject { page }

  context 'as admin' do
    # Need constants but don't know which is best way in RSpec
    let(:users)   { 'Users' }

    let!(:admin)  do
      FactoryGirl.create(:user, :admin, person: FactoryGirl.create(:person, role: 'admin', first_name: admin_first_name, home_phone: admin_home_phone))
    end

    let!(:standard_user)  do
      person = FactoryGirl.create(:person, first_name: user_first_name, home_phone: user_home_phone)
      FactoryGirl.create(:user, person: person)
    end

    before do
      visit_signin_and_login admin
      visit users_path
      expect(current_path).to eq users_path
    end

    describe 'create user' do
      it 'open page' do
        click_on('Create User')
        expect(current_path).to eq signup_path
      end
    end

    describe 'pagination' do
      before(:all) do
        20.times do
          FactoryGirl.create(:user, person: FactoryGirl.create(:person))
        end
      end
      after(:all)   do
        User.delete_all
        Person.delete_all
        Address.delete_all
      end

      it 'present' do
        should have_selector('div.pagination')
      end

      it 'should list each user' do
        page.has_link?('alice user')
        page.has_link?('bob_admin')
        page.has_link?('John_Smith')
      end
    end

    describe 'search' do
      let(:search) { 'search' }
      let(:search_button) { 'go_search' }

      before do
        expect(page).to have_text(admin_first_name)
        expect(page).to have_text(user_first_name)
      end

      context 'by name' do
        before do
          fill_in(search, with: admin_first_name)
          click_button(search_button)
        end
        it ('returned matches') { expect(page).to have_text(admin_first_name) }
        it ('left unmatched') { expect(page).to_not have_text(user_first_name) }
      end

      context 'by phone number' do
        before do
          fill_in(search, with: admin_home_phone[2, 5])
          click_button(search_button)
        end
        it ('returned matches') { expect(page).to have_text(admin_first_name) }
        it ('left unmatched') { expect(page).to_not have_text(user_first_name) }
      end
    end   # search

    describe 'User links' do
      describe 'Edit' do
        context 'a standard user' do
          it ('present') { should have_link('Edit', href: edit_profile_path(standard_user)) }
          it 'edits' do
            first(:link, 'Edit').click
            expect(current_path).to eq edit_profile_path(standard_user)
          end
        end

        context 'an admin user' do
          let!(:admin_edit_self) { FactoryGirl.create(:user, :admin, person: FactoryGirl.create(:person, first_name: 'admin_edit_self')) }
          before { visit users_path }
          it ('present for self-edit') { should have_link('Edit', href: edit_profile_path(admin)) }
        end
      end

      describe 'Delete' do
        let!(:admin_undeleteable) { FactoryGirl.create(:user, :admin, person: FactoryGirl.create(:person, first_name: 'admin_undeletable')) }
        before { visit users_path }

        context 'a standard user' do
          it ('present') { should have_link('Delete', href: user_path(standard_user)) }
          it ('deletes') { expect { first(:link, 'Delete').click }.to change(User, :count).by(-1) }
        end

        context 'an admin user' do
          it 'missing for self' do
            should_not have_link('Delete', href: user_path(admin))
          end
        end
      end
    end # user links
  end # index
end
