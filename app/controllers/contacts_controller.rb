#
# ContactsController
#
#   - managing requests for 'Contact Me'
#
class ContactsController < ApplicationController
  before_action :guest_redirect_to_signin_path
  check_authorization
  load_and_authorize_resource

  def index
    if current_user.gardener?
      @contacts = current_user.calls.outstanding.includes(:person)
    else
      @contacts = current_user.contacts.outstanding.includes(:person)
    end
  end

  def create
    @contact = Contact.new contact_params
    if @contact.save
      redirect_to contacts_path, flash: { notice: 'Contact me was successfully created.' }
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @contact.update contact_params
      redirect_to contacts_path, flash: { notice: 'Contact me was successfully updated.' }
    else
      render :edit
    end
  end

  def destroy
    @contact.destroy
    redirect_to contacts_path, flash: { alert: 'Contact Deleted!' }
  end

  private

  def contact_params
    params.require(:contact)
      .permit :additional_information,
              :appointee_id,
              :between_end,
              :between_start,
              :completed,
              :person_id,
              :by_phone,
              :by_visit,
              :touch_from,
              :visit_at
  end
end
