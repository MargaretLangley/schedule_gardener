#
# UsersController
#  - manage users within the application
#
class UsersController < ApplicationController
  before_action :guest_redirect_to_signin_path,   except: [:new, :create]
  check_authorization
  load_and_authorize_resource

  def index
    @users = User.search_ordered(params[:search]).paginate(per_page: 10, page: params[:page])
  end

  def show
  end

  def new
    @user = User.new
    @user.contact = Contact.new
    @user.contact.address = Address.new
  end

  def create
    @user = User.new user_params
    if @user.save
      signed_in? ? create_another_user : new_user_signed_up
    else
      render :new
    end
  end

  def create_another_user
    redirect_to users_path, flash: { notice: 'New User Created' }
  end

  def new_user_signed_up
    sign_in_remember_session @user
    redirect_to dashboard_path(@user), flash: { notice: 'Welcome to Garden Care!' }
  end

  def edit
  end

  def update
    if @user.update user_params
      if editing_self
        flash.now[:notice] = 'Profile updated'
        # if the account we are using changes, The remember token changes
        # we then need to re-signin
        sign_in_remember_session @user
        render 'edit'
      else
        redirect_to users_path, flash: { notice: 'Updated User' }
      end
    else
      render :edit
    end
  end

  def editing_self
    current_user?(@user)
  end

  def destroy
    User.find(params[:id]).destroy
    redirect_to users_path, flash: { alert: 'User Deleted!.' }
  end

  private

  def user_params
    params.require(:user)
      .permit :password,
              :password_confirmation,
              contact_attributes: contact_params
  end

  def contact_params
    %i(email first_name home_phone last_name mobile) +
      [address_attributes: address_params]
  end

  def address_params
    %i(house_name street_number street_name address_line_2 town post_code)
  end
end
