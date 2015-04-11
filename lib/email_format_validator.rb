
class EmailFormatValidator < ActiveModel::EachValidator
  def validate_each(object, attribute, value)
    return if value =~ /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]+\z/

    object.errors[attribute] << (options[:message] || 'is not formatted properly')
  end
end
