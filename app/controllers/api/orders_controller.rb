class Api::OrdersController < ApplicationController
  respond_to :json

  def index
    gig = Gig.find params[:gig_id]
    @orders = gig.orders
  end

  def show
    gig = Gig.find params[:gig_id]
    @order = gig.orders.find params[:id]
  end

  def update
    render :json => params[:order]
  end
end
