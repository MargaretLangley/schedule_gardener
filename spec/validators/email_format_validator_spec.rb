require 'spec_helper'

module EmailFormat
  #
  # Class created for testing Validator
  #
  class Validatable
    include ActiveModel::Validations
    attr_reader :email
    validates :email, email_format: true

    def initialize email
      @email = email
    end
  end
end

describe EmailFormatValidator do
  def validatable(email:)
    EmailFormat::Validatable.new email
  end

  it 'with good format are valid' do
    %w(usr@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn).each do |valid_email|
      expect(validatable(email: valid_email)).to be_valid
    end
  end

  it 'with bad format are invalid' do
    email_addresses = %w(us_at_foo.org)

    email_addresses.each do |invalid_address|
      expect(validatable(email: invalid_address)).to_not be_valid
    end
  end
end
