class UsersController < ApplicationController

  before_filter :guest_redirect_to_signin_path,   except: [:new, :create]
  check_authorization
  load_and_authorize_resource


  def index
    @users = User.search_ordered(params[:search]).paginate(per_page: 10, page: params[:page])
  end


  def show
  end


  def new
    @user.contact = Contact.new
    @user.contact.address = Address.new
  end


  def create
    if @user.save
      sign_in_remember_session @user
      redirect_to @user, flash: { success: "Welcome to Garden Care!" }
    else
      render 'new'
    end
  end


  def edit
  end


  def update
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated"

      # if the account we are using changes, The remember token changes
      # we then need to re-signin
      sign_in_remember_session @user if current_user?(@user)
    end
    render 'edit'
  end


  def destroy
    User.find(params[:id]).destroy
    redirect_to users_path , flash: { success: "user destroyed." }
  end


end
