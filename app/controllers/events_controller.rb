# to make the HTML more bootstrap twittery... follow this link
# http://stackoverflow.com/questions/11279394/fullcalendar-with-twitter-bootstrap

class EventsController < ApplicationController

  load_and_authorize_resource :appointment, parent: false

  def index

    if params.has_key?(:start)
      # FullCalendar calls its events source (/calendars url) with  start and end UNIX time stamp.
      @appointments = @appointments.in_time_range(Time.at(params[:start].to_i) .. Time.at(params[:end].to_i))
    end

    @events = @appointments.map {|appointment| appointment.to_event}

    respond_to do |format|
       format.html # index.html.erb
       format.json { render json: @events }
     end
  end
end