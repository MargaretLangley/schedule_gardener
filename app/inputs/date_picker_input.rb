#
# DatePickerInput
#
# This is a way to clear up the usage of the datepicker in the view
# Which is now:
#   <%= f.input :deadline, :as => :date_picker %>
#
# Stackoverflow http://stackoverflow.com/a/10504204/1511504
#
class DatePickerInput < SimpleForm::Inputs::StringInput
  def input(wrapper_options = {})
    value = object.send(attribute_name) if object.respond_to? attribute_name
    input_html_options[:value] ||= I18n.localize(value) if value.present?
    input_html_classes << 'datepicker'

    super # leave StringInput do the real rendering
  end
end
