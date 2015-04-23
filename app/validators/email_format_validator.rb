#
# EmailFormatValidator
#   - class to validate email
#   - strong argument to simplify email validation as something that contains @
#     - there always ends up being exceptions to any regex.
#     - regex for email is complex and introduces complex bugs
#       - some chars and an @ and some chars and an end
#
# Reference
#   - http://ruby-doc.org/core-2.2.1/Regexp.html
#
class EmailFormatValidator < ActiveModel::EachValidator
  def validate_each(object, attribute, value)
    return if value =~ /
                       \A      # the beginning of the line
                       \S+     # negates 'any single whitespace'
                       @       # the @ char
                       \S+     # negates 'any single whitespace'
                       \z      # end of string
                       /x      # multi-line regex

    object.errors[attribute] << (options[:message] || 'is not formatted properly')
  end
end
