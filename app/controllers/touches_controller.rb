class TouchesController < ApplicationController
  before_action :guest_redirect_to_signin_path
  check_authorization
  load_and_authorize_resource

  def index
    if current_user.role == 'gardener'
      @touches = Touch.outstanding
    else
      @touches = Touch.outstanding_by_contact(current_user.contact)
    end
  end

  def create
    @touch = Touch.new touch_params
    @touch.save!
    redirect_to touches_path, flash: { success: 'Contact me was successfully created.' }
   rescue ActiveRecord::RecordInvalid
     render :new
  end

  def edit
  end

  def update
    @touch.update touch_params
    redirect_to touches_path, flash: { success: 'Contact me was successfully updated.' }
    rescue ActiveRecord::RecordInvalid
      render :edit
  end

  def destroy
    @touch.destroy
    redirect_to touches_path
  end

  private

  def touch_params
    params.require(:touch)
      .permit :additional_information,
              :between_end,
              :between_start,
              :completed,
              :contact_id,
              :by_phone,
              :by_visit,
              :touch_from,
              :visit_at
  end
end
