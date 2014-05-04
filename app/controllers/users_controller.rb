class UsersController < ApplicationController
  before_action :signed_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user,    only: [:edit, :update]
  before_action :admin_user,     only: :destroy
  before_action :not_signed_in_user,  only: [:new, :create]


  def destroy

    @user = User.find_by_id(params[:id])
    if @user && current_user?(@user)
      redirect_to root_url
    else

      User.find(params[:id]).destroy
      flash[:success] = "User deleted."
      redirect_to users_url
    end
  end

  def index
    @users = User.paginate(page: params[:page])
  end

  def new
  	@user = User.new
  end

  def create
  	@user = User.new(user_params)
  	if @user.save
      sign_in @user
  		flash[:success] = "Welcome to the Sample App!"
  		redirect_to @user
  	else
  		render 'new'
  	end
  end

  def show

#  	@user = User.find(params[:id])
#  Using find_by_id because this returns nil so that it can be checked for invalid user
#  Otherwise find by itself will raise an exception if user is not present

    @user = User.find_by_id(params[:id])
    if @user && current_user?(@user)
      render
    else
      redirect_to signin_url
    end

  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  private

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end

  	def user_params
  		params.require(:user).permit(:name, :email, :password,
  									 :password_confirmation)
  	end

    # Before filters

    def not_signed_in_user
      if signed_in?
        redirect_to(root_url)
      end
    end

    def signed_in_user
      unless signed_in?
        store_location
        redirect_to signin_url, notice: "Please sign in." unless signed_in?
      end
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
end
