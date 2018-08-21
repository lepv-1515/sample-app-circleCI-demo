# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  include SessionsHelper

  def hello
    render html: "hello, mysample_app!"
  end

  def not_found
    render file: "#{Rails.root}/public/404.html", status: 404
  end

  def logged_in_user
    return true if logged_in?
    store_location
    flash[:warning] = t "users.logged_in_user.warning_mess"
    redirect_to login_path
  end
end
