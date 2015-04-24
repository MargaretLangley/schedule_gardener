module ApplicationHelper
  def application_title_pipe_page_title(page_title)
    application_title = 'Garden Care'
    if page_title.empty?
      application_title
    else
      "#{application_title} | #{page_title}"
    end
  end

  def format_minutes_as_hrs_mins(minutes)
    hours = minutes / 60
    remainder_minutes = minutes % 60
    remainder_minutes == 0 ? "#{hours}hrs" : "#{hours}hrs #{remainder_minutes}mins"
  end

  def number_to_phone_without_area_code(phone_number)
    number_to_phone(phone_number.sub(/^0121/, ''))
  end

  def link_to_edit(path)
    link_to 'Edit', path, class: 'btn btn-default btn-xs'
  end

  def link_to_delete(path)
    link_to 'Delete', path,
            data: { confirm: 'Are you sure you want to delete?' },
            method: 'delete',
            class: 'btn btn-danger btn-xs'
  end
end
