# ContactHelper
#
# Helper methods for contact
#
module ContactHelper
  # information
  #  - information to identify a contact
  #
  def information contact
    "#{contact.full_name} / #{phone_without_area_code(contact.home_phone)}"
  end
end
