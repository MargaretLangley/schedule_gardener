class TouchesController < ApplicationController
  before_filter :guest_redirect_to_signin_path
  check_authorization
  load_and_authorize_resource

  def index
    if current_user.role == "gardener"
      @touches = Touch.outstanding()
    else
      @touches = Touch.outstanding_by_contact(current_user.contact)
    end

  end

  def create
    @touch.save!
    redirect_to touches_path, flash: { success: 'Contact me was successfully created.' }
   rescue ActiveRecord::RecordInvalid
     render :new
  end

  def edit
  end

  def update
    @touch.update_attributes!(params[:touch])
    redirect_to touches_path, flash: { success: 'Contact me was successfully updated.' }
    rescue ActiveRecord::RecordInvalid
      render :edit
  end

  def destroy
    redirect_to touches_path
  end
end
