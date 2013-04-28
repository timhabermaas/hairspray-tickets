class Api::OrdersController < ApplicationController
  respond_to :json

  def index
    @orders = gig.orders
  end

  def show
    @order = gig.orders.find params[:id]
  end

  def create
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

  def pay
    order = gig.orders.find params[:id]

    order.update_attributes paid_at: Time.now

    respond_with(:api, gig, order)
  end

  def unpay
    order = gig.orders.find params[:id]

    order.update_attributes paid_at: nil

    respond_with(:api, gig, order)
  end

  private
  def gig
    @gig ||= Gig.find params[:gig_id]
  end
end
