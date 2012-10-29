class TouchesController < ApplicationController
  before_filter :guest_redirect_to_signin_path
  check_authorization
  load_and_authorize_resource

  def index
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
    redirect_to touches_path, flash: { success: 'Contact me was successfully updated.' }
  end

  def destroy
    redirect_to touches_path
  end
end
