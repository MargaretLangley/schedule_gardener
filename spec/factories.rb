FactoryGirl.define do
  factory :user do
    password "foobar"
    password_confirmation "foobar"

    factory :admin do
      admin true
    end
    association :contact, strategy: :build
  end

  factory :contact do
    sequence(:first_name) { |n| "Firstname#{n}" }
    sequence(:last_name)  { |n| "Lastname#{n}" }
    email                 { "#{first_name}.#{last_name}@example.com".downcase }
    sequence(:home_phone) { |n| "0181-100-100#{n}" }
    sequence(:mobile)     { |n| "0701-200-200#{n}" }
    association :address, strategy: :build
  end

  factory :garden do
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

  factory :event do
    title "New Example Event"
    starts_at {Time.now.utc.beginning_of_day + 9.hours }
    ends_at { starts_at + 3.hours }
    all_day false
    description "I am describing a new example event. For testing only."
  end

end

