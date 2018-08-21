class PasswordResetsController < ApplicationController
  before_action :load_user, :valid_user, :check_expire, only: %i(edit update)

  def new; end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t ".info_mess"
      redirect_to root_path
    else
      flash.now[:danger] = t ".danger_mess"
      render :new
    end
  end

  def edit; end

  def update
    if params[:user][:password].blank?
      @user.errors.add(:password, t(".error_mess"))
      render :edit
    elsif @user.update_attributes(user_params)
      log_in @user
      flash[:success] = t ".success_mess"
      redirect_to @user
    else
      render :edit
    end
  end

  private

  def load_user
    @user = User.find_by email: params[:email]
    return not_found unless @user
  end

  def valid_user
    if @user&.activated? && @user.authenticated?(:reset, params[:id])
      return true
    end
    redirect_to root_path
  end

  def check_expire
    return true unless @user.password_reset_expired?
    flash[:danger] = t ".danger_mess"
    redirect_to new_password_reset_path
  end

  def user_params
    params.require(:user).permit :password, :password_confirmation
  end
end
