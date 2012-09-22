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
  end

  def edit
    @appointment = Appointment.find(params[:id])
  end

  def create
    @appointment = Appointment.new(params[:appointment])

    respond_to do |format|
      if @appointment.save
        format.html { redirect_to @appointment, notice: 'appointment was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
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
