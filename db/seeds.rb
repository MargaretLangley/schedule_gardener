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
									 phone_number: "0171000001")

address = Address.new(	street_number: "10",
												street_name: "High Street",
												town: "London",
												post_code: "N10 0AA"
												)

user.address = address
user.toggle(:admin)
user.save


user = User.new(first_name: "admin",
									 last_name: "",
									 email: "admin@gardencare.com",
									 password: "RUMin8te$",
									 password_confirmation: "RUMin8te$",
									 phone_number: "0171000002")

address = Address.new(	street_number: "11",
												street_name: "High Street",
												town: "London",
												post_code: "N10 0AA"
												)
user.address = address

user.toggle(:admin)
user.save