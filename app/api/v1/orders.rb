class API::V1::Orders < API::Base
  helpers Authorization::Helpers

  namespace "/gigs/:gig_id" do

    helpers do
      def gig
        Gig.find(params["gig_id"])
      end
    end

    resource :orders do

      desc "Fetches all orders."
      get "/", rabl: "orders" do
        @orders = gig.orders.includes(:seats => :row)
      end

      segment do # restricted to user, admin

        before { authorize! :user, :admin }

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

        segment "/:id" do

          helpers do
            def order
              @order ||= gig.orders.find(params["id"])
            end
          end

          desc "Pay an order."
          post "/pay", rabl: "order" do
            order.pay!
            status 200
          end


          before do
            authorize!(:admin) if order.paid?
          end

          desc "Update an order."
          params do
            requires :name, type: String, desc: "Name"
            requires :reduced_count, type: Integer, desc: "Amount of reduced tickets"
            requires :seat_ids, type: Array, desc: "Seats to be reserved"
          end
          put "/", rabl: "order" do
            if !order.update_attributes(declared(params))
              error!({"error" => order.errors}, 422)
            end
          end

          desc "Delete an order."
          delete "/" do
            order.destroy
          end

          desc "Unpay an order."
          post "/unpay", rabl: "order" do
            order.unpay!
            status 200
          end

        end
      end
    end
  end
end
