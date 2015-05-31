
require 'spec_helper'

describe 'PasswordReset' do
  subject { page }

  let(:client) do
    person = FactoryGirl.create(:person, :client_j)
    FactoryGirl.create(:user, :resetting_password, person: person)
  end

  context '#new' do
    it 'should open page' do
      visit new_password_reset_path

      expect(current_path).to eq new_password_reset_path
    end

    context 'with valid email' do
      # Requires smtp server to be running
      #
      context 'in database' do
        it 'open password resent' do
          visit new_password_reset_path
          fill_in 'email',       with: 'me@example.com'
          click_button 'Email me password reset instructions'

          expect(current_path).to eq password_reset_sent_path
        end

        it 'Notice message set' do
          visit new_password_reset_path
          fill_in 'email',       with: 'me@example.com'
          click_button 'Email me password reset instructions'

          should have_flash_notice('Email sent with password reset instructions.')
        end
      end

      context 'absent from database' do
        it 'still messages that you have reset' do
          visit new_password_reset_path
          fill_in 'email',       with: 'unknown.user@example.com'
          click_button 'Email me password reset instructions'

          expect(current_path).to eq password_reset_sent_path
        end

        it 'Notice message set' do
          visit new_password_reset_path
          fill_in 'email',       with: 'unknown.user@example.com'
          click_button 'Email me password reset instructions'

          should have_flash_notice('Email sent with password reset instructions.')
        end
      end
    end

    context 'when enter invalid email' do
      it 'waits on the create action' do
        visit new_password_reset_path
        fill_in 'password_reset_email',       with: 'email@example,com'
        click_button 'Email me password reset instructions'

        expect(current_path).to eq password_resets_path
      end

      it 'has error banner' do
        visit new_password_reset_path
        fill_in 'password_reset_email',       with: 'email@example,com'
        click_button 'Email me password reset instructions'

        should have_content('error')
      end
    end
  end

  context '#edit' do
    context 'within time' do
      it 'opens page' do
        visit edit_password_reset_path(client.password_reset_token)

        expect(current_path).to eq edit_password_reset_path(client.password_reset_token)
      end

      context 'good input' do
        before do
          visit edit_password_reset_path(client.password_reset_token)
          fill_in 'Password', with: 'password'
          fill_in 'Confirm password', with: 'password'
          click_button 'Update Password'
        end
        it 'matching passwords succeed' do
          expect(current_path).to eq root_path
        end
        it 'should display notice' do
          should have_flash_notice('Password has been reset')
        end
      end

      context 'bad input' do
        before do
          visit edit_password_reset_path(client.password_reset_token)
          fill_in 'Password', with: 'password'
          fill_in 'Confirm password', with: 'wrong'
          click_button 'Update Password'
        end
        it 'has error banner' do
          should have_content('error')
        end
      end
    end
    context 'out of time' do
      let!(:client_expired) do
        person = FactoryGirl.create(:person, :client_j)
        FactoryGirl.create(:user, :expired_reset_password, person: person)
      end

      it 'opens new reset page' do
        visit edit_password_reset_path(client_expired.password_reset_token)

        expect(current_path).to eq new_password_reset_path
      end

      it 'has flash error' do
        visit edit_password_reset_path(client_expired.password_reset_token)

        should have_flash_error('Password reset has expired.')
      end
    end
  end
end
