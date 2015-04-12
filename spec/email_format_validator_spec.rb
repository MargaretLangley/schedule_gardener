require 'spec_helper'

class SomeRecord
  attr_accessor :email
  attr_reader :errors

  def initialize(attrs = {})
    @email = attrs.delete(:email)
    @errors = ActiveModel::Errors.new(self)
  end

  def read_attribute_for_validation(attr)
    send(attr)
  end
end

describe EmailFormatValidator do
  subject(:email_format_validator) { EmailFormatValidator.new(attributes: [:email]) }

  it 'with good format are valid' do
    %w(usr@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn).each do |valid_email|
      record = SomeRecord.new(email: valid_email)
      email_format_validator.validate(record)
      expect(record.errors[:email]).to be_empty
    end
  end

  it 'with bad format are invalid' do
    email_addresses = %w(us@foo,com us_at_foo.org example.user@foo.
                         foo@bar_baz.com foo@bar+baz.com)

    email_addresses.each do |invalid_address|
      record = SomeRecord.new(email: invalid_address)
      email_format_validator.validate(record)
      expect(record.errors[:email]).to include('is not formatted properly')
    end
  end
end
