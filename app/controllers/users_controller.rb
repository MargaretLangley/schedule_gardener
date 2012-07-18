class UsersController < ApplicationController
  before_filter :signed_in_user, only: [:edit, :update,:index, :destroy]
  before_filter :correct_user, only: [:edit, :update]
  before_filter :admin_user,     only: :destroy
  # 9.6.6 
  #before_filter :unsigned_in_can_create, only: [:create, :new]

  def index
    @users = User.search(params[:search]).paginate(per_page: 20, page: params[:page])
  end


	def show
		@user = User.find(params[:id])
	end

  def new
  	@user = User.new
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
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "user destroyed."
    redirect_to users_path
  end

  private

    def signed_in_user
      # signed_in? means sessions helper has the @user set
      unless signed_in?
        store_location
        redirect_to signin_path, notice: 'Please sign in.' unless signed_in?
      end
    end

    # 9.6.6 but don't know what doing
    # def unsigned_in_can_create
    #   redirect_to(root_path) if signed_in? 
    # end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end  

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
end
