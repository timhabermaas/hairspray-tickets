class API::V1::Orders < Grape::API
  extend Authorization

  restrict_access_to :admin, :user

  resource :gigs do

    namespace "/:gig_id" do

      helpers do
        def gig
          Gig.find(params["gig_id"])
        end
      end

      resource :orders do

        desc "Fetches all orders."
        get "/", rabl: "orders" do
          @orders = gig.orders
        end

        desc "Create an order."
        params do
          requires :name, type: String, desc: "Name"
          requires :reduced_count, type: Integer, desc: "Amount of reduced tickets"
          requires :seat_ids, type: Array, desc: "Seats to be reserved"
        end
        post "/", rabl: "order" do
          @order = gig.orders.build declared(params)
          if !@order.save
            error!({"error" => @order.errors}, 422)
          end
        end

        desc "Delete an order."
        delete "/:id" do
          order = gig.orders.find(params["id"])
          order.destroy
        end

        desc "Update an order."
        params do
          requires :name, type: String, desc: "Name"
          requires :reduced_count, type: Integer, desc: "Amount of reduced tickets"
          requires :seat_ids, type: Array, desc: "Seats to be reserved"
        end
        put "/:id", rabl: "order" do
          @order = gig.orders.find params["id"]
          if !@order.update_attributes(declared(params))
            error!({"error" => @order.errors}, 422)
          end
        end

        desc "Pay an order."
        post "/:id/pay", rabl: "order" do
          @order = gig.orders.find(params["id"])
          @order.pay!
          status 200
        end

        desc "Unpay an order."
        post "/:id/unpay", rabl: "order" do
          @order = gig.orders.find(params["id"])
          @order.unpay!
          status 200
        end
      end
    end
  end
end
