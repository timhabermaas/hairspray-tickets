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

  def create
    gig = Gig.find params[:gig_id]
    order = gig.orders.build params[:order]
    if order.save
      render :json => order
    else
      render :json => order.errors, :status => 422
    end
  end

  def update
    order = Order.find params[:id]
    if order.update_attributes params[:order]
      render :json => order
    else
      render :json => order.errors, :status => 422
    end
  end
end
