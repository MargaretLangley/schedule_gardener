# PersonHelper
#
# Helper methods for person
#
module PersonHelper
  # information
  #  - information to identify a person
  #
  def information person
    "#{person.full_name} / #{phone_without_area_code(person.home_phone)}"
  end
end
