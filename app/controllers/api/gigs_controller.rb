class Api::GigsController < ApplicationController
  respond_to :json

  def index
    @gigs = Gig.all
  end

  def show
    render :json => Gig.find(params[:id])
  end
end
