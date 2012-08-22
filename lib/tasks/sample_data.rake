namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    Faker::Config.locale = 'en-gb'
    admin = User.create!(first_name: "Example",
                 last_name: "User",
                 email: "example@railstutorial.org",
                 password: "foobar",
                 password_confirmation: "foobar",
                 address_line_1: "12 High Street",
                 town:  "London",
                 home_phone: "0181-333-8888")
    admin.toggle!(:admin)
    99.times do |n|
      first_name  = Faker::Name.first_name
      last_name = Faker::Name.last_name
      email = Faker::Internet.email(first_name + "." + last_name)
      password  = "password"
      address_line_1 = Faker::Address.street_address
      town = Faker::Address.city
      home_phone = Faker::PhoneNumber.home_phone
      User.create!(first_name: first_name,
                   last_name: last_name,
                   email: email,
                   password: password,
                   password_confirmation: password,
                   address_line_1: address_line_1,
                   town: town,
                   home_phone: home_phone)
    end
  end
end