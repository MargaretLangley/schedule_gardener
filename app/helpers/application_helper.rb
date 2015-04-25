# ApplicationHelper
#
# Helper methods used in a number of views.
#
module ApplicationHelper
  #
  # application title string
  #   - string that appears in the application's tab
  #
  # page_title - string we would like page to show
  #
  def application_titleized(page_title:)
    application_title = 'Garden Care'
    if page_title.empty?
      application_title
    else
      "#{application_title} | #{page_title}"
    end
  end

  # format_minutes_as_hrs_mins
  #   - minutes into exact hours and minutes
  #   - distance_of_time_in_words only gives approximate time
  #
  def format_minutes_as_hrs_mins(minutes)
    hours = minutes / 60
    remainder_minutes = minutes % 60
    remainder_minutes == 0 ? "#{hours}hrs" : "#{hours}hrs #{remainder_minutes}mins"
  end

  # phone_without_area_code
  #   - phone number without the common local numbers
  #
  # phone_number - the number we would like to shorten
  #
  def phone_without_area_code(phone_number)
    number_to_phone(phone_number.sub(/^0121/, ''))
  end

  # Edit link with bootstrap classes
  #
  def link_to_edit(path)
    link_to 'Edit', path, class: 'btn btn-default btn-xs'
  end

  # Delete link with bootstrap classes
  #
  def link_to_delete(path)
    link_to 'Delete', path,
            data: { confirm: 'Are you sure you want to delete?' },
            method: 'delete',
            class: 'btn btn-danger btn-xs'
  end
end
