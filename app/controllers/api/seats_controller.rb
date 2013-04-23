class Api::SeatsController < ApplicationController
  respond_to :json

  def index
    @seats = Seat.includes(:row)
  end
end
