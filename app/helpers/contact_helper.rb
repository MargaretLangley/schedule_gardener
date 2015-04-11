module ContactHelper
  def formatted_full_name_plus_contact(contact = @contact)
    contact.full_name + ' / ' + number_to_phone_without_area_code(contact.phone_number)
  end
end
