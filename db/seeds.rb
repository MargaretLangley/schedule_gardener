# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


user = User.new(first_name: "Margaret", 
									 last_name: "Langley",
									 email: "margaret.b.langley@gmail.com",
									 password: "RUMin8te$",
									 password_confirmation: "RUMin8te$",
									 address_line_1: "Unavailable",
									 town: "Unavailable",
									 phone_number: "000")

user.toggle(:admin)
user.save


user = User.new(first_name: "admin",
									 last_name: "",
									 email: "admin@gardencare.com",
									 password: "RUMin8te$",
									 password_confirmation: "RUMin8te$",
									 address_line_1: "Unavailable",
									 town: "Unavailable",
									 phone_number: "000")

user.toggle(:admin)
user.save