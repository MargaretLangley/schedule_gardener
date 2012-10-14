class AppointmentsController < ApplicationController
  before_filter :guest_redirect_to_signin_path
  check_authorization
  load_and_authorize_resource


  def index

    @appointments = current_user.visits if current_user.role == "gardener"

    if params.has_key?(:begin) && params.has_key?(:end)
      @appointments = @appointments.in_time_range(Time.parse(params[:begin]) .. Time.parse(params[:end])).order('starts_at ASC')
    else
      @appointments = @appointments.after_now()
    end

  end


  def new
  end


  def create
    if @appointment.save
      redirect_to appointments_path, flash: { success: 'appointment was successfully created.' }
    else
      render :new
    end
  end


  def edit
  end


  def update
    if @appointment.update_attributes(params[:appointment])
      redirect_to appointments_path, flash: { success: 'appointment was successfully updated.' }
    else
      render :edit
    end
  end


  def destroy
    @appointment.destroy
    redirect_to appointments_path
  end

end
