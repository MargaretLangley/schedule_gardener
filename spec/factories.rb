# rubocop: disable  Style/EmptyLines

FactoryGirl.define do
  # USER
  #  - has_one person
  #
  factory :user do
    password 'foobar'
    password_confirmation 'foobar'

    trait :admin do
      association :person, :admin, strategy: :build
    end

    trait :resetting_password do
      password_reset_token 'i8pCKXq7UArg164qUXfJXg'
      password_reset_sent_at { Time.zone.now }
    end

    trait :expired_reset_password do
      password_reset_token 'expiredTimedOutXXXXXXg'
      password_reset_sent_at { Time.zone.now - 2.hours - 5.minutes }
    end
  end



  # PERSON
  #   - belongs_to user
  #   - has_many gardens
  #   - has_many appointments
  #   - has_many contacts
  #   - has_many visits
  #
  factory :person do
    user
    first_name 'person_trait_not_set'
    last_name 'person_trait_not_set'
    email  { "#{first_name}.#{last_name}@example.com".downcase }
    home_phone '0181-100-1001'
    mobile '0701-200-2007'
    role 'client'
    association :address, strategy: :build

    trait :admin do
      first_name 'Alice'
      last_name 'Springs'
      role 'admin'
    end

    trait :client_a do
      first_name 'Ann'
      last_name 'Abbey'
      home_phone '0181-100-1001'
      role 'client'
    end

    trait :client_j do
      first_name 'John'
      last_name 'Smith'
      home_phone '0181-100-2002'
      role 'client'
    end

    trait :client_r do
      first_name 'Roger'
      last_name 'Smith'
      home_phone '0181-100-3003'
      role 'client'
    end

    trait :gardener_a do
      first_name 'Alan'
      last_name 'Titmarsh'
      home_phone '0181-200-1001'
      role 'gardener'
    end

    trait :gardener_p do
      first_name 'Percy'
      last_name 'Thrower'
      home_phone '0181-200-2002'
      role 'gardener'
    end
  end



  # GARDEN
  #   - belongs_to person
  #   - has_one address
  #
  factory :garden do
    person
  end

  factory :garden_own_address, parent: :garden, class: 'Garden'  do
    association :address, street_number: '16', street_name: 'Garden Avenue'
  end



  # ADDRESS
  #   - belongs_to addressable
  #
  factory :address do
    house_name ''
    street_number '15'
    street_name 'High Street'
    address_line_2 'Stratford'
    town 'London'
    post_code 'NE12 3ST'
  end



  # APPOINTMENT
  #   - belongs_to person  (class name person)
  #   - belongs_to appointee  (class name person)
  #
  factory :appointment do
    person
    association :appointee, factory: :person, first_name: 'Alan', last_name: 'Titmarsh', role: 'gardener'
    starts_at '2012-09-01 09:30:00'
    ends_at '2012-09-01 11:00:00'
    description 'I am describing a new example event. For testing only.'

    #
    # persons
    #
    trait :client_a do
      association :person, :client_a
    end

    trait :client_r do
      association :person, :client_r
    end

    trait :gardener_a do
      association :appointee, factory: :person, first_name: 'Alan', last_name: 'Titmarsh', role: 'gardener'
    end

    trait :gardener_p do
      association :appointee, factory: :person, first_name: 'Percy', last_name: 'Thrower', role: 'gardener'
    end

    #
    # times
    #
    trait :today_first_slot do
      starts_at '2012-09-01 09:30:00'
      ends_at '2012-09-01 11:00:00'
    end

    trait :today_second_slot do
      starts_at '2012-09-01 11:30:00'
      ends_at '2012-09-01 13:00:00'
    end

    trait :today_third_slot do
      starts_at '2012-09-01 13:30:00'
      ends_at '2012-09-01 15:00:00'
    end

    trait :today_fourth_slot do
      starts_at '2012-09-01 15:30:00'
      ends_at '2012-09-01 17:00:00'
    end

    trait :tomorrow_first_slot do
      starts_at '2012-09-02 9:30:00'
      ends_at '2012-09-02 11:00:00'
    end

    trait :next_week_first_slot do
      starts_at '2012-09-08 9:30:00'
      ends_at '2012-09-08 11:00:00'
    end

    trait :next_month_first_slot do
      starts_at '2012-10-01 9:30:00'
      ends_at '2012-10-01 11:00:00'
    end
  end



  # CONTACT
  #   - belongs_to person
  #
  factory :contact do
    association :person, :client_a
    association :appointee, factory: :person, first_name: 'Alan', last_name: 'Titmarsh', role: 'gardener'
    by_phone true
    by_visit false
    touch_from '2012-09-15'
    completed false

    #
    # persons
    #
    trait :client_a do
      association :person, :client_a
    end

    trait :client_j do
      association :person, :client_j
    end

    trait :client_r do
      association :person, :client_r
    end

    #
    # times
    #
    trait :today do
      touch_from '2012-09-01'
    end

    trait :tomorrow do
      touch_from '2012-09-02'
    end

    trait :next_week do
      touch_from '2012-09-08'
    end

    trait :fortnight do
      touch_from '2012-09-15'
    end
  end
end
