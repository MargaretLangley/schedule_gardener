class AppointmentsController < ApplicationController

  before_filter :signed_in_user

  def index
    @user = User.find(params[:user_id])
    @appointments = @user.contact.appointments
  end

  def show
    @appointment = Appointment.find(params[:id])
  end

  def new
    @user = User.find(params[:user_id])
    @appointment = Appointment.new
    @appointment.build_event
    @gardeners = Contact.gardeners
  end


  def create
    @user = User.find(params[:user_id])
    @appointment = Appointment.new(params[:appointment])
    @appointment.contact = @user.contact

    if @appointment.save
      redirect_to user_appointments_path(@user), flash: { success: 'appointment was successfully created.' }
    else
      render :new
    end
  end

  def edit
    @user = User.find(params[:user_id])
    @appointment = @user.contact.appointments.find(params[:id])
    @gardeners = Contact.gardeners
  end

  def update
    @user = User.find(params[:user_id])
    @appointment = Appointment.find(params[:id])
    if @appointment.update_attributes(params[:appointment])
      redirect_to user_appointments_path(@user), flash: { success: 'appointment was successfully updated.' }
    else
      render :edit
    end
  end

  def destroy
    @appointment = Appointment.find(params[:id])
    @appointment.destroy
  end


end
