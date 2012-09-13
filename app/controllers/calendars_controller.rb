class CalendarsController < ApplicationController

  # to make the HTML more bootstrap twittery... follow this link
  # http://stackoverflow.com/questions/11279394/fullcalendar-with-twitter-bootstrap
  def show

    if params.has_key?(:start)
      # When FullCalendar displays it calls it's events source (/calendars url)
      # it filters with a start and end UNIX time stamp.
      @events = Event.in_time_range( Time.at(params[:start].to_i) .. Time.at(params[:end].to_i) )
    else
      @events = Event.all
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @events }
    end
  end

    # GET /events/1/edit
  def edit
    logger.debug "CalendarsController#edit"
    @event = Event.find(params[:id])
  end

    # PUT /events/1
  # PUT /events/1.json
  def update
    logger.debug "CalendarsController#update"
    # @event = Event.find(params[:id])

    # respond_to do |format|
    #   if @event.update_attributes(params[:event])
    #     format.html { redirect_to @event, notice: 'Event was successfully updated.' }
    #     format.json { head :no_content }
    #   else
    #     format.html { render action: "edit" }
    #     format.json { render json: @event.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  def index
    logger.debug "CalendarsController#index"
  end

end