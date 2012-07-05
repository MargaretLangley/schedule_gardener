FactoryGirl.define  do
	factory :user do
		first_name						"Richard"
		last_name							"Wigley"
		email									"richard.wigley@gmail.com"
		password							"foobar"
		password_confirmation "foobar"
		town									"Sutton Coldfield"
		address_line_1				"55 Essex Road" 
		phone_number					"0121-308-1439"
	end
end