class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user?, only: :destroy
  before_action :load_user, only: [:show, :edit, :update, :destroy]

  def index
    @users = User.paginate(page: params[:page],
                           per_page: Settings.paginate.per_page)
  end

  def new
    @user = User.new
  end

  def show; end

  def create
    @user = User.new user_params
    if @user.save
      log_in @user
      flash[:success] = t ".success_mess"
      redirect_to @user
    else
      render :new
    end
  end

  def edit; end

  def update
    if @user.update_attributes user_params
      flash[:success] = t ".success_mess"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    flash[:success] = t ".success_mess"
    redirect_to users_path
  end

  private
  def user_params
    params.require(:user).permit :name, :email, :password,
      :password_confirmation
  end

  def logged_in_user
    return true if logged_in?
    store_location
    flash[:warning] = t "users.logged_in_user.warning_mess"
    redirect_to login_path
  end

  def admin_user?
    redirect_to root_path unless current_user.admin?
  end

  def correct_user
    load_user
    redirect_to root_path unless current_user? @user
  end

  def load_user
    @user = User.find params[:id]
  end
end
