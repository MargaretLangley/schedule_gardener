FactoryGirl.define do
  factory :user do
    password "foobar"
    password_confirmation "foobar"

    trait :admin do
      admin true
      association :contact, role: "admin", strategy: :build
    end

    trait :client do
      association :contact, role: "client", strategy: :build
    end

    trait :gardener do
      association :contact, role: "gardener", strategy: :build
    end
  end

  factory :contact do
    sequence(:first_name) { |n| "Firstname#{n}" }
    sequence(:last_name)  { |n| "Lastname#{n}" }
    email                 { "#{first_name}.#{last_name}@example.com".downcase }
    sequence(:home_phone) { |n| "0181-100-100#{n}" }
    sequence(:mobile)     { |n| "0701-200-200#{n}" }
    association :address, strategy: :build
    role "client"
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
    all_day false
    description "I am describing a new example event. For testing only."

    trait :today do
      starts_at {Time.now.utc.beginning_of_day + 9.hours }
    end
    trait :tomorrow do
      starts_at {Time.now.utc.beginning_of_day + 9.hours + 1.days }
    end

    trait :two_days_time do
      starts_at {Time.now.utc.beginning_of_day + 9.hours + 2.days }
    end
    ends_at { starts_at + 3.hours }

  end

  factory :appointment do
    association :contact, first_name: "Rodger"
    association :appointee, factory: :contact, first_name: "Percy"

    trait :today do
      association :event, :today, title: "created by appointment today"
    end

    trait :tomorrow do
      association :event, :tomorrow, title: "created by appointment tomorrow"
    end

    trait :two_days_time do
      association :event, :two_days_time, title: "created by appointment two_days_time"
    end


  end

end

