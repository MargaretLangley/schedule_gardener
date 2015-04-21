require 'spec_helper'

describe PasswordResetsController do
  let(:client) { FactoryGirl.create(:user, :client_a)  }

  describe '#create' do
    # getting smtp error in test but works in dev (ERR CONN 2)
    xit 'should receive an known email to send' do
      mail = FactoryGirl.build(:message)
      UserMailer.should_receive(:password_reset).with(client).and_return(mail)
      post :create, password_reset: { email: 'john.smith@example.com' }
    end

    it 'should not receive an unknown email to send' do
      expect(UserMailer).to_not receive(:password_reset)
      post :create, password_reset: { email: 'unknown.user@example.com' }
    end

    it 'should deliver the signup email' do
      expect(Rails.logger).to receive(:info).with('unknown email requested for password reset: unknown.user@example.com')
      post :create, password_reset: { email: 'unknown.user@example.com' }
    end
  end

  describe '#update' do
    it 'should redirect a put with an expired token' do
      client_with_expired_token = create_user
      post :update, id: client_with_expired_token.password_reset_token
      expect(response).to redirect_to new_password_reset_path
    end

    def create_user
      contact = FactoryGirl.create(:contact, :client_j)
      FactoryGirl.create(:user, :expired_reset_password, contact: contact)
    end
  end
end
