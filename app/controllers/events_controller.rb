
class EventsController < ApplicationController
  before_filter :guest_redirect_to_signin_path
  check_authorization
  load_and_authorize_resource :appointment, parent: false

  def index

    @appointments_by_date = @appointments.group_by {|appointment| appointment.starts_at.to_date}
    @date = params[:date] ? Date.parse(params[:date]) : Date.today

    # # FullCalendar calls its events source (/calendars url) with  start and end UNIX time stamp.
    # @appointments = @appointments.in_time_range(Time.at(params[:start].to_i) .. Time.at(params[:end].to_i)) if params.has_key?(:start)

    # @events = @appointments.map {|appointment| appointment.to_event}

  end
end