class GigsController < ApplicationController
  respond_to :json

  def index
    render :json => Gig.all
  end

  def show
    render :json => Gig.find(params[:id])
  end
end
