class Api::SessionsController < ApplicationController
  def create
    if params[:name] == credentials[:name] and params[:password] == credentials[:password]
      cookies[:logged_in] = true
      render :json => { logged_in: true }
    else
      cookies[:logged_in] = false
      render :json => { logged_in: false }, :status => 400
    end
  end

  private
  def credentials
    @credentials ||= Rails.application.config.credentials
  end
end
