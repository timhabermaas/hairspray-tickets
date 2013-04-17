class Api::OrdersController < ApplicationController
  respond_to :json

  def index
    respond_with []
  end
end
