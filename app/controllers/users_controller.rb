class UsersController < ApplicationController
  # signing in must happen before testing filters allowed_user and admin_user
  # we should be signed in except when creating a new user
  before_filter :signed_in_user,      except: [:new, :create]

  before_filter :allowed_user,        only: [ :show, :edit,  :update]
  before_filter :allowed_admin_user,  only: [ :index, :destroy]
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
    @user.address = Address.new
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


    #  only people who are signed in can access users pages
    def signed_in_user
      # signed_in? means sessions helper has the @user set
      unless signed_in?
        store_location
        redirect_to signin_path, notice: 'Please sign in.' unless signed_in?
      end
    end


    def allowed_admin_user
       unless current_user.admin? 
        sign_out
        redirect_to(root_path)  
       end
    end

    # 9.6.6 but don't know what doing
    # def unsigned_in_can_create
    #   redirect_to(root_path) if signed_in? 
    # end


    # clicking an edit link sets id to the user you clicked
    # current user assigns @current_user from cookie if null
    # current user is the user returned from the cookie 
    def allowed_user
      @user = User.find(params[:id])
      unless (current_user?(@user) || current_user.admin?)
        sign_out
        redirect_to(root_path) 
      end
    end 

end
