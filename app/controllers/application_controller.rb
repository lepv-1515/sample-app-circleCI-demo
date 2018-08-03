# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  def hello
    render html: "hello, mysample_app!"
  end

  def not_found
    render file: "#{Rails.root}/public/404.html", status: 404
  end
end
