#
# TouchesController
#
#   - managing requests for 'Contact Me'
#   - touch is word used in models, 'Contact Me' is for the user.
#
class TouchesController < ApplicationController
  before_action :guest_redirect_to_signin_path
  check_authorization
  load_and_authorize_resource

  def index
    if current_user.gardener?
      @touches = Touch.outstanding
    else
      @touches = Touch.outstanding_by_contact(current_user.contact)
    end
  end

  def create
    @touch = Touch.new touch_params
    if @touch.save
      redirect_to touches_path, flash: { notice: 'Contact me was successfully created.' }
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @touch.update touch_params
      redirect_to touches_path, flash: { notice: 'Contact me was successfully updated.' }
    else
      render :edit
    end
  end

  def destroy
    @touch.destroy
    redirect_to touches_path, flash: { alert: 'Contact Deleted!' }
  end

  private

  def touch_params
    params.require(:touch)
      .permit :additional_information,
              :appointee_id,
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
