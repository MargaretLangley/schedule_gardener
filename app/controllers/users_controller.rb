class UsersController < ApplicationController

  # signing in must happen before testing filters allowed_user and admin_user
  # we should be signed in except when creating a new user
  before_filter :signed_in_user,      except: [:new, :create]
  before_filter :allowed_user,        only: [ :show, :edit,  :update]
  before_filter :allowed_admin_user,  only: [ :index, :destroy]

  def index
    @users = User.search_ordered(params[:search]).paginate(per_page: 20, page: params[:page])
  end


  def show
    @user = User.find(params[:id])

  end

  def new
    @user = User.new
    @user.contact = Contact.new
    @user.contact.address = Address.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to Garden Care!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated"
      # 9.10 changing account results in the remember token getting reset
      # so we login again.

      #sign_in if we are the user
      sign_in @user if current_user?(@user)
    end
    render 'edit'
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "user destroyed."
    redirect_to users_path
  end

end
