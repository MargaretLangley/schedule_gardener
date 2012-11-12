
class EventsController < ApplicationController
  before_filter :guest_redirect_to_signin_path
  check_authorization
  load_and_authorize_resource :appointment, parent: false

  def index
    @date = blank_param_date? ? default_date : param_date
    @appointments_by_date = @appointments.in_time_range(@date..@date.end_of_month()).group_by {|appointment| appointment.starts_at.to_date}
  end

  def blank_param_date?
    params[:date].blank?
  end

  def param_date
    Date.parse(params[:date])
  end

  def default_date
    Date.current.beginning_of_month()
  end
end