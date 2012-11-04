module ApplicationHelper

  def application_title_pipe_page_title(page_title)
    application_title = "Garden Care"
    if page_title.empty?
      application_title
    else
      "#{application_title} | #{page_title}"
    end
  end

end