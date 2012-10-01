class AppointmentsController < ApplicationController
  before_filter :guest_redirect_to_signin_path
  check_authorization
  load_and_authorize_resource

  def index
  end


  def new
    @appointment.build_event
    @gardeners = Contact.gardeners
  end


  def create
    if @appointment.save
      redirect_to appointments_path, flash: { success: 'appointment was successfully created.' }
    else
      render :new
    end
  end


  def edit
    @gardeners = Contact.gardeners
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
