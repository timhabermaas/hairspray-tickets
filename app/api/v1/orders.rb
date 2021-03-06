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
          optional :email, type: String, desc: "Email address for notifying customer"
        end
        post "/", rabl: "order" do
          @order = gig.orders.build declared(params)
          if @order.save
            OrderMailer.ordered_email(@order).deliver if @order.email.present?
          else
            error!({error: @order.errors}, 400)
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
            OrderMailer.payment_confirmation_email(order).deliver if order.email.present?
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
            optional :email, type: String, desc: "Email address for notifying customer"
          end
          put "/", rabl: "order" do
            order.assign_attributes(declared(params))
            email_changed = order.email_changed?

            if order.save
              OrderMailer.ordered_email(order).deliver if order.email.present? and email_changed
            else
              error!({error: order.errors}, 400)
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
