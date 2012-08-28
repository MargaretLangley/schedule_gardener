FactoryGirl.define do
  factory :user do
    password "foobar"
    password_confirmation "foobar"

    factory :admin do
      admin true
    end
    contact
  end

  factory :contact do
    sequence(:first_name) { |n| "Firstname#{n}" }
    sequence(:last_name)  { |n| "Lastname#{n}" }
    email                 { "#{first_name}.#{last_name}@example.com".downcase }
    sequence(:home_phone) { |n| "0181-100-100#{n}" }
    sequence(:mobile)     { |n| "0701-200-200#{n}" }
    address
  end

  factory :garden do
    contact
  end

  factory :garden_own_address, parent: :garden, class:"Garden"  do
    association :address, street_number: "16", street_name: "Garden Avenue" 
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

