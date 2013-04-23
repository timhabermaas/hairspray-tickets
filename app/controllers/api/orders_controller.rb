class Api::OrdersController < ApplicationController
  respond_to :json

  ORDERS = [{id: 1, name: "Peter Mustermann", seats: [1, 4], paid: false, reduced: 1}, {id: 2, name: "Dieter Mustermann", seats: [2, 3, 5], paid: true, reduced: 2}]

  def index
    render :json => ORDERS
  end

  def show
    render :json => ORDERS.find { |o| o[:id] == params[:id]}
  end

  def update
    render :json => params[:order]
  end
end
