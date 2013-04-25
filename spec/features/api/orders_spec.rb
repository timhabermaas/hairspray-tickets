require "spec_helper"

describe "/api/gigs/:gig_id/orders/:id" do
  let(:gig) { Gig.create! title: "Gig #1", date: Time.new(2013, 4) }
  let(:row) { Row.create! number: 2, y: 3 }
  let(:seat_1) { Seat.create! number: 3, x: 4, row: row }

  it "returns the order and its reserved seats" do
    order = Order.create! gig: gig, name: "Dieter", seats: [seat_1]

    get "/api/gigs/#{gig.id}/orders/#{order.id}.json"
    response = JSON.parse(last_response.body)

    expect(response["name"]).to eq("Dieter")
    expect(response["gig"]["title"]).to eq("Gig #1")
    expect(response["seats"][0]["number"]).to eq(3)
  end
end
