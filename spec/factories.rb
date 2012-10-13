FactoryGirl.define do
  factory :user do
    password "foobar"
    password_confirmation "foobar"

    trait :admin do
      admin true
      association :contact, :admin, strategy: :build
    end

    trait :client do
      association :contact, :client_j, strategy: :build
    end


    trait :client_a do
      association :contact, :client_a, strategy: :create
    end

    trait :client_j do
      association :contact, :client_j, strategy: :create
    end

    trait :client_r do
      association :contact, :client_r, strategy: :create
    end


    trait :gardener do
      association :contact, :gardener_a, strategy: :build
    end

    trait :unexpected do
      association :contact, :client_a, role: "unexpected", strategy: :build
    end

    trait :resetting_password do
      password_reset_token "i8pCKXq7UArg164qUXfJXg"
      password_reset_sent_at {Time.zone.now}
    end

    trait :expired_reset_password do
      password_reset_token "expiredTimedOutXXXXXXg"
      password_reset_sent_at {Time.zone.now - 2.hours - 5.minutes}
    end
  end


  factory :contact do

    trait :admin do
      first_name 'Alice'
      last_name 'Springs'
      role 'admin'
    end

    trait :client_a do
      first_name 'Ann'
      last_name  'Abbey'
      role 'client'
    end

    trait :client_j do
      first_name 'John'
      last_name  'Smith'
      role 'client'
    end


    trait :client_r do
      first_name 'Roger'
      last_name  'Smith'
      role 'client'
    end

    trait :gardener_a do
      first_name 'Alan'
      last_name  'Titmarsh'
      role 'gardener'
    end

    trait :gardener_p do
      first_name 'Percy'
      last_name  'Thrower'
      role 'gardener'
    end

    email                 { "#{first_name}.#{last_name}@example.com".downcase }
    sequence(:home_phone) { |n| "0181-100-100#{n}" }
    mobile '0701-200-2007'
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


  factory :appointment do

    trait :client do
      association :contact, :client_r
    end

    trait :gardener_a do
      association :appointee, factory: :contact, first_name: "Alan", last_name: "Titmarsh", role: "gardener"
    end

    trait :gardener_p do
      association :appointee, factory: :contact, first_name: "Percy", last_name: "Thrower", role: "gardener"
    end


    title "Appointment"
    all_day false
    description "I am describing a new example event. For testing only."

    trait :today do
      title "created by appointment today"
      starts_at {Time.now.utc.beginning_of_day + 9.hours }
    end
    trait :tomorrow do
      title "created by appointment tomorrow"
      starts_at {Time.now.utc.beginning_of_day + 9.hours + 1.days }
    end

    trait :two_days_time do
      title "created by appointment two_days_time"
      starts_at {Time.now.utc.beginning_of_day + 9.hours + 2.days }
    end
    trait :three_days_time do
      title "created by appointment two_days_time"
      starts_at {Time.now.utc.beginning_of_day + 9.hours + 3.days }
    end

    ends_at { starts_at + 3.hours }

  end

  factory :message, class: Mail::Message do
    #multipart false
    from 'from@example.com'
    to  'john.smith@example.com'
    subject 'Password Reset'
  end

end

#<Mail::Message:89263770, Multipart: false, Headers: <From: from@example.com>, <To: john.smith@example.com>, <Subject: Password Reset>, <Mime-Version: 1.0>, <Content-Type: text/plain>>

