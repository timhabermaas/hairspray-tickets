require "spec_helper"

describe API::V1::Orders do
  let!(:gig) { Gig.create! title: "Gig #1", date: DateTime.new(2013, 4) }
  let!(:gig_2) { Gig.create! title: "Gig #2", date: DateTime.new(2013, 4) }
  let!(:row) { Row.create! number: 2, y: 3 }
  let!(:seat_1) { Seat.create! number: 3, x: 4, row: row }
  let!(:seat_2) { Seat.create! number: 4, x: 5, row: row }
  let!(:order) { Order.create! gig: gig, name: "Dieter", seats: [seat_1], paid_at: DateTime.new(2013, 4, 5), reduced_count: 1 }
  let!(:order_2) { Order.create! gig: gig_2, name: "Peter", seats: [seat_1] }

  context "when logged in" do

    before(:all) do
      login_with_name_and_role("hans", :user)
    end

    after(:all) do
      Account.delete_all
    end

    context "fetching orders" do

      subject! do
        get api_base_path + "/gigs/#{gig.id}/orders"
      end

      let(:api_key) { create_valid_api_key_for(:user) }

      its(:status) { should eq(200) }

      it "returns all orders for that gig" do
        expect(parsed_response).to have(1).item
        expect(parsed_response[0]["name"]).to eq("Dieter")
        expect(parsed_response[0]["paid"]).to eq(true)
        expect(DateTime.parse(parsed_response[0]["paid_at"])).to eq(DateTime.new(2013, 4, 5))
        expect(parsed_response[0]["reduced_count"]).to eq(1)
      end

      it "includes reserved seats" do
        expect(parsed_response[0]["seats"]).to have(1).item
        expect(parsed_response[0]["seats"][0]["number"]).to eq(3)
        expect(parsed_response[0]["seats"][0]["row"]["number"]).to eq(2)
      end

    end

    context "creating an order" do

      let(:order_hash) do
        {
          name: "Peter",
          reduced_count: 0,
          seat_ids: [seat_1.id]
        }
      end

      subject! do
        post api_base_path + "/gigs/#{gig.id}/orders", order_hash
      end

      context "valid parameters" do

        its(:status) { should eq(201) }

        it "returns a newly created order" do
          expect(parsed_response["id"]).to_not be_nil
          expect(parsed_response["name"]).to eq("Peter")
        end

      end

      context "invalid parameters" do

        let(:order_hash) do
          {
            reduced_count: 0,
            seat_ids: [seat_1.id]
          }
        end

        its(:status) { should eq(400) }

        it "returns the error" do
          expect(parsed_response["error"]).to eq("missing parameter: name")
        end

      end
    end

    context "updating an order" do

      let(:order_hash) do
        {
          name: "Peter",
          reduced_count: 0,
          seat_ids: [seat_1.id]
        }
      end

      subject! do
        put api_base_path + "/gigs/#{gig.id}/orders/#{order.id}", order_hash
      end

      context "valid parameters" do

        its(:status) { should eq(200) }

        it "updates the record" do
          expect(order.reload.reduced_count).to eq(0)
        end

        it "returns the updated record" do
          expect(parsed_response["name"]).to eq("Peter")
          expect(parsed_response["reduced_count"]).to eq(0)
        end

      end

      context "invalid parameters" do

        let(:order_hash) do
          {
            reduced_count: 0,
            seat_ids: [seat_1.id]
          }
        end

        its(:status) { should eq(400) }

        it "doesn't update the record" do
          expect(order.reload.reduced_count).not_to eq(0)
        end

      end
    end

    context "deleting an order" do

      subject! do
        delete api_base_path + "/gigs/#{gig.id}/orders/#{order.id}"
      end

      its(:status) { should eq(200) }

      it "returns the deleted order" do
        expect(parsed_response["name"]).to eq("Dieter")
      end

      it "removes the specified order" do
        expect(Order.count).to eq(1)
        expect(Order.first.id).to_not eq(order.id)
      end

    end

    context "paying an order" do

      let(:order) { FactoryGirl.create :not_paid_order, name: "Peter" }

      subject! do
        post api_base_path + "/gigs/#{order.gig.id}/orders/#{order.id}/pay"
      end

      its(:status) { should eq(200) }

      it "sets paid flag to true" do
        expect(order.reload).to be_paid
      end

      it "returns an updated model" do
        expect(parsed_response["name"]).to eq("Peter")
        expect(parsed_response["paid"]).to eq(true)
      end

    end

    context "unpaying an order" do

      let(:order) { FactoryGirl.create :paid_order, name: "Peter" }

      subject! do
        post api_base_path + "/gigs/#{order.gig.id}/orders/#{order.id}/unpay"
      end

      its(:status) { should eq(200) }

      it "sets paid flag to false" do
        expect(order.reload).to_not be_paid
      end

      it "returns an updated model" do
        expect(parsed_response["name"]).to eq("Peter")
        expect(parsed_response["paid"]).to eq(false)
      end

    end
  end

  context "when not logged in" do

    context "fetching orders" do

      subject! do
        get api_base_path + "/gigs/#{gig.id}/orders"
      end

      its(:status) { should eq(200) }

      it "does not contain any names nor reduced_counts" do
        expect(parsed_response[0]["name"]).to be_nil
        expect(parsed_response[0]["reduced_count"]).to be_nil
      end

      it "returns the reserved seats" do
        expect(parsed_response[0]["seats"][0]["number"]).to eq(3)
        expect(parsed_response[0]["seats"][0]["row"]["number"]).to eq(2)
      end

    end

    context "creating an order" do

      subject! do
        post api_base_path + "/gigs/#{gig.id}/orders"
      end

      # TODO write matcher for not authorized response
      its(:status) { should eq(401) }

      it "returns 'not authorized'" do
        expect(parsed_response["error"]).to eq("not authorized")
      end

    end

    context "updating an order" do

      subject! do
        put api_base_path + "/gigs/#{gig.id}/orders/#{order.id}"
      end

      its(:status) { should eq(401) }

      it "returns 'not authorized'" do
        expect(parsed_response["error"]).to eq("not authorized")
      end

    end

    context "deleting an order" do

      subject! do
        delete api_base_path + "/gigs/#{gig.id}/orders/#{order.id}"
      end

      its(:status) { should eq(401) }

      it "returns 'not authorized" do
        expect(parsed_response["error"]).to eq("not authorized")
      end

    end

    context "paying an order" do

      subject! do
        post api_base_path + "/gigs/#{order.gig.id}/orders/#{order.id}/pay"
      end

      its(:status) { should eq(401) }

      it "returns 'not authorized" do
        expect(parsed_response["error"]).to eq("not authorized")
      end

    end

    context "unpaying an order" do

      subject! do
        post api_base_path + "/gigs/#{order.gig.id}/orders/#{order.id}/unpay"
      end

      its(:status) { should eq(401) }

      it "returns 'not authorized" do
        expect(parsed_response["error"]).to eq("not authorized")
      end
    end
  end
end
