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

    trait :email_tester do
      association :contact, :client_a, email: 'richard.wigley@gmail.com', strategy: :create
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
      home_phone "0181-100-1001"
    end

    trait :client_j do
      first_name 'John'
      last_name  'Smith'
      role 'client'
      home_phone "0181-100-2002"
    end


    trait :client_r do
      first_name 'Roger'
      last_name  'Smith'
      role 'client'
      home_phone "0181-100-3003"
    end

    trait :gardener_a do
      first_name 'Alan'
      last_name  'Titmarsh'
      role 'gardener'
      home_phone "0181-200-1001"
    end

    trait :gardener_p do
      first_name 'Percy'
      last_name  'Thrower'
      role 'gardener'
      home_phone "0181-200-2002"
    end

    email  { "#{first_name}.#{last_name}@example.com".downcase }
    home_phone "0181-100-1001"
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

    description "I am describing a new example event. For testing only."

    trait :today_first_slot do
      starts_at "2012-09-01 09:30:00"
      ends_at   "2012-09-01 11:00:00"
    end
    trait :today_second_slot do
      starts_at "2012-09-01 11:30:00"
      ends_at "2012-09-01 13:00:00"
    end

    trait :today_third_slot do
      starts_at "2012-09-01 13:30:00"
      ends_at "2012-09-01 15:00:00"
    end
    trait :today_fourth_slot do
      starts_at "2012-09-01 15:30:00"
      ends_at "2012-09-01 17:00:00"
    end

    trait :tomorrow_first_slot do
      starts_at "2012-09-02 9:30:00"
      ends_at "2012-09-02 11:00:00"
    end

    trait :next_week_first_slot do
      starts_at "2012-09-08 9:30:00"
      ends_at "2012-09-08 11:00:00"
    end

    length_of_appointment 90

    # factory girl does not follow pattern of rails creation.
    # FG creates an opbect and then assigns values and then saves
    # This causes FG to not use the initialize hook for appointment correctly
    # by nilling out these values I allow the appointment to initialize
    # itself properly in model_synchronise_accessors.
    after(:build) do |appointment|
      appointment.starts_at_date = nil
      appointment.starts_at_time = nil
      appointment.length_of_appointment = nil
      appointment.model_synchronise_accessors
    end
  end


  factory :touch do

    trait :client_r do
      association :contact, :client_r
    end

  end

end

