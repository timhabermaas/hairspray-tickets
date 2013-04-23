class Api::SeatsController < ApplicationController
  def index
    @rows = Row.all
  end
end
