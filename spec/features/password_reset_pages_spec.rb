
require 'spec_helper'

describe 'PasswordReset' do
  subject { page }

  let(:client) do
    contact = FactoryGirl.create(:contact, :client_j)
    FactoryGirl.create(:user, :resetting_password, contact: contact)
  end

  context '#new' do
    before do
      visit new_password_reset_path
    end

    it 'should open page' do
      expect(current_path).to eq new_password_reset_path
    end

    context 'with valid email' do
      before do
        contact = FactoryGirl.create(:contact, email: 'me@example.com')
        FactoryGirl.create(:user, contact: contact)
      end
      context 'in database' do
        before do
          fill_in 'email',       with: 'me@example.com'
          click_button 'Email me password reset instructions'
        end

        # 'not setup for sendgrid - look at options later'
        xit 'open password resent' do
          expect(current_path).to eq password_reset_sent_path
        end

        # 'not setup for sendgrid - look at options later'
        xit 'Notice set' do
          should have_flash_notice('Email sent with password reset instructions.')
        end
      end

      context 'absent from database' do
        context 'after submits' do
          before do
            fill_in 'email',       with: 'unknown.user@example.com'
            click_button 'Email me password reset instructions'
          end

          it 'open password resent' do
            expect(current_path).to eq password_reset_sent_path
          end

          it 'Notice set' do
            should have_flash_notice('Email sent with password reset instructions.')
          end
        end
      end
    end

    context 'when enter invalid email' do
      before do
        fill_in 'password_reset_email',       with: 'email@example,com'
        click_button 'Email me password reset instructions'
      end

      it 'waits on the create action' do
        expect(current_path).to eq password_resets_path
      end

      it 'has error banner' do
        should have_content('error')
      end
    end
  end

  context '#edit' do
    before do
      visit edit_password_reset_path(client.password_reset_token)
    end
    context 'within time' do
      it 'opens page' do
        expect(current_path).to eq edit_password_reset_path(client.password_reset_token)
      end
      context 'good input' do
        before do
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
        contact = FactoryGirl.create(:contact, :client_j)
        FactoryGirl.create(:user, :expired_reset_password, contact: contact)
      end
      before do
        visit edit_password_reset_path(client_expired.password_reset_token)
      end

      it 'opens new reset page' do
        expect(current_path).to eq new_password_reset_path
      end

      it 'has flash error' do
        should have_flash_error('Password reset has expired.')
      end
    end
  end
end
