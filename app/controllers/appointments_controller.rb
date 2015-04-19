#
# AppointmentsController
#   - Management of appointments
#     - Where an appointment is a client arranging a time, slot, with a gardener
#
class AppointmentsController < ApplicationController
  before_action :guest_redirect_to_signin_path
  helper_method :active_nav?
  check_authorization
  load_and_authorize_resource

  def index
    @appointments = current_user.visits if current_user.role == 'gardener'
    @appointments = @appointments.in_time_range(time_range_from_params_or_session).order('starts_at ASC')
  end

  def time_range_from_params_or_session
    initialize_nil_params_from_session
    initialize_session_from_params

    if missing_time_range
      Time.zone.now..Time.zone.today + 1.year
    else
      Time.zone.parse(params[:begin])..Time.zone.parse(params[:end])
    end
  end

  def initialize_nil_params_from_session
    params[:nav] ||= session[:nav]
    params[:begin] ||= session[:begin]
    params[:end] ||= session[:end]
  end

  def initialize_session_from_params
    session[:nav]   = params[:nav]
    session[:begin] = params[:begin]
    session[:end]   = params[:end]
  end

  def missing_time_range
    params[:begin].blank? && params[:end].blank?
  end

  def active_nav?(link)
    params[:nav] == link
  end

  #
  # new appointment
  #   - start_at: the time an appointment begins.
  #
  def new
    @appointment = Appointment.new(starts_at: params[:starts_at])
  end

  def create
    @appointment = Appointment.new appointment_params
    @appointment.save!
    redirect_to appointments_path, flash: { success: 'appointment was successfully created.' }
   rescue ActiveRecord::RecordInvalid
     render :new
  end

  def update
    @appointment.update appointment_params
    redirect_to appointments_path, flash: { success: 'appointment was successfully updated.' }
    rescue ActiveRecord::RecordInvalid
      render :edit
  end

  def destroy
    @appointment.destroy
    redirect_to appointments_path
  end

  private

  def appointment_params
    params.require(:appointment)
      .permit :appointee,
              :appointee_id,
              :contact_id,
              :description,
              :ends_at,
              :starts_at,
              appointment_time_attributes: appointment_time_params
  end

  def appointment_time_params
    %i(start_date start_time length)
  end
end
