class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user&.authenticate params[:session][:password]
      if user.activated?
        wellcome_login user
      else
        flash[:warning] = t ".warning_mess"
        redirect_to root_path
      end
    else
      flash.now[:danger] = t ".danger_mess"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_path
  end

  private

  def remember_me user
    if params[:session][:remember_me] == Settings.remember_me
      remember user
    else
      forget user
    end
  end

  def wellcome_login user
    log_in user
    remember_me user
    redirect_back_or user
  end
end
