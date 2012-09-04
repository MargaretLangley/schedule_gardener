# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

	user = User.new(
									password: "RUMin8te$",
									password_confirmation: "RUMin8te$", 
									contact_attributes: {
																first_name: "Margaret", 
																last_name: 	"Gardener", 
																email: 			"gardener1@gardencare.com",
																home_phone: "0171000002",
																address_attributes: {
																	street_number: "11",
																	street_name: "High Street",
																	address_line_2: "Stratford",
																	town: "London",
																	post_code: "NE12 3ST"
																}
									}
									)

user.toggle(:admin)
user.save

user = User.new(
								password: "RUMin8te$",
								password_confirmation: "RUMin8te$", 
								contact_attributes: {
															first_name: "admin", 
															last_name: 	"gardencare", 
															email: 			"admin@gardencare.com",
															home_phone: "0171000001",
															address_attributes: {
																street_number: "12",
																street_name: "High Street",
																address_line_2: "Stratford",
																town: "London",
																post_code: "NE12 3ST"
															}
								}
								)

user.toggle(:admin)
user.save