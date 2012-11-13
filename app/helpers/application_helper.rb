module ApplicationHelper

  def application_title_pipe_page_title(page_title)
    application_title = "Garden Care"
    if page_title.empty?
      application_title
    else
      "#{application_title} | #{page_title}"
    end
  end

  def number_to_phone_without_area_code(phone_number)
    number_to_phone(phone_number.sub(/^0121/,''))
  end


  def link_to_edit(path)
    link_to 'Edit', path, class: 'tenerary_action_button'
  end

  def link_to_delete(path)
    link_to 'Delete', path, confirm: 'Are you sure you want to delete?' , method: 'delete', class: 'tenerary_action_button_warn'
  end


end