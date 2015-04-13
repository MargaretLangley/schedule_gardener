#
# EmailFormatValidator
#   - class to validate email
#   - strong argument to simplify email validation as something that contains @
#     - there always ends up being exceptions to any regex.
#     - regex for email is complex and introduces complex bugs
#   TODO: simplify regex to be @
#
class EmailFormatValidator < ActiveModel::EachValidator
  def validate_each(object, attribute, value)
    return if value =~ /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]+\z/

    object.errors[attribute] << (options[:message] || 'is not formatted properly')
  end
end
