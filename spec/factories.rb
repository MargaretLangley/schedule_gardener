FactoryGirl.define do
  factory :user do
    sequence(:first_name) { |n| "Person #{n}" }
    sequence(:last_name)  { |n| "Surname #{n}" }
    sequence(:email)      { |n| "person_#{n}@example.com"}
    password "foobar"
    password_confirmation "foobar"
    sequence(:address_line_1)	{ |n| "#{n} High Street" }
    town									"London"
    sequence(:phone_number)		{ |n| "0181-308-143#{n}" }

    factory :admin do
      admin true
    end
  end
end

