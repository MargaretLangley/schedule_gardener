class UsersController < ApplicationController
  # signing in must happen before testing filters allowed_user and admin_user
  before_filter :signed_in_user,  only: [:index, :edit, :update, :destroy]

  before_filter :allowed_user,    only: [:edit,  :update]
  before_filter :admin_user,      only: [:index, :destroy]
  # 9.6.6 
  #before_filter :unsigned_in_can_create, only: [:create, :new]

  def index
    @users = User.search_ordered(params[:search]).paginate(per_page: 20, page: params[:page])
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
      # 9.10 changing account results in the remember token getting reset
      # so we login again. 

      #sign_in if we are the user
      sign_in @user if current_user?(@user)
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

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end

    # 9.6.6 but don't know what doing
    # def unsigned_in_can_create
    #   redirect_to(root_path) if signed_in? 
    # end

    def allowed_user
      @user = User.find(params[:id])
      # Current user assigns @current_user from cookie if null
      redirect_to(root_path) unless current_user?(@user) || admin_user?(@user)
    end 

    def signed_in_user
      # signed_in? means sessions helper has the @user set
      unless signed_in?
        store_location
        redirect_to signin_path, notice: 'Please sign in.' unless signed_in?
      end
    end

end
