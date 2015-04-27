#
# EventsController
#   - Displays the calendar view
#
class EventsController < ApplicationController
  before_action :guest_redirect_to_signin_path
  check_authorization
  load_and_authorize_resource :appointment, parent: false

  #
  # Calendar View
  #
  def index
    @date = params[:date].blank? ? default_date : Date.parse(params[:date])
    @appointments_by_date = @appointments
                            .includes(:contact)
                            .in_time_range(@date - 7.day..@date.end_of_month + 7.day)
                            .group_by { |appointment| appointment.starts_at.to_date }
  end

  def default_date
    Time.zone.today.beginning_of_month
  end
end
