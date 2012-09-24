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
      redirect_to user_appointments_path(@user), notice: 'appointment was successfully created.'
    else
      render :new
    end
  end

  def edit
    @appointment = Appointment.find(params[:id])
  end

  def update
     @appointment = Appointment.find(params[:id])

    # respond_to do |format|
    #   if @appointment.update_attributes(params[:appointment])
    #     format.html { redirect_to @appointment, notice: 'appointment was successfully updated.' }
    #   else
    #     format.html { render action: "edit" }
    #   end
    # end
  end

  def destroy
    @appointment = Appointment.find(params[:id])
    @appointment.destroy
  end


end
