require "spec_helper"

describe "orders" do
  let(:gig) { Gig.create! title: "Gig #1", date: Time.new(2013, 4) }
  let(:row) { Row.create! number: 2, y: 3 }
  let(:seat_1) { Seat.create! number: 3, x: 4, row: row }
  let!(:order) { Order.create! gig: gig, name: "Dieter", seats: [seat_1] }

  let(:response) { JSON.parse(last_response.body) }

  describe "/api/gigs/:gig_id/orders/:id" do
    it "returns the order and its reserved seats" do
      get "/api/gigs/#{gig.id}/orders/#{order.id}.json"

      expect(response["name"]).to eq("Dieter")
      expect(response["gig"]["title"]).to eq("Gig #1")
      expect(response["seats"][0]["number"]).to eq(3)
    end
  end

  describe "/api/gigs/:gig_id/orders/:id/pay" do
    it "sets paid_at to current time" do
      post "/api/gigs/#{gig.id}/orders/#{order.id}/pay.json"

      expect(Order.first).to be_paid
      expect(response["name"]).to eq("Dieter")
    end
  end

  describe "/api/gigs/:gig_id/orders/:id/unpay" do
    it "unsets paid_at" do
      post "/api/gigs/#{gig.id}/orders/#{order.id}/unpay.json"

      expect(Order.first).to_not be_paid
      expect(Order.first.paid_at).to be_nil
      expect(response["name"]).to eq("Dieter")
    end
  end
end
