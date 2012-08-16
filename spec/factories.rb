FactoryGirl.define do
  factory :user do
    sequence(:first_name) { |n| "Person #{n}" }
    sequence(:last_name)  { |n| "Surname #{n}" }
    sequence(:email)      { |n| "person_#{n}@example.com"}
    password "foobar"
    password_confirmation "foobar"
    sequence(:phone_number)		{ |n| "0181-308-143#{n}" }

    factory :admin do
      admin true
    end

    address
  end


  factory :letter do
    stamp true
    address
  end


  factory :address do
    house_name ""
    street_number "15"
    street_name "High Street"
    address_line_2 "Stratford"
    town "London"
    post_code "NE12 3ST"
  end

end

