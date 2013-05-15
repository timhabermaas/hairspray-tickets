require "spec_helper"

describe API::V1::Gigs do
  before :each do
    @seats = []
    row = Row.create! :y => 2, :number => 2
    5.times do |seat|
      @seats << Seat.create!(:row => row, :x => seat, :number => seat)
    end
    Seat.create! :row => row, :x => 10, :number => 10, :usable => false
  end

  context "fetching gigs" do
    subject! do
      gig_1 = Gig.create! title: "Gig #1", date: Time.now
      gig_2 = Gig.create! title: "Auftritt #3", date: Time.now
      order = Order.create! gig: gig_2, name: "Peter"
      Reservation.create! seat: @seats[0], order: order
      Reservation.create! seat: @seats[1], order: order

      get api_base_path + "/gigs"
    end

    its(:status) { should eq(200) }

    it "returns all gigs" do
      expect(last_response.status).to eq(200)
      expect(parsed_response).to have(2).items
      expect(parsed_response[0]["title"]).to eq("Gig #1")
      expect(parsed_response[0]["free_seats"]).to eq(5)
      expect(parsed_response[1]["title"]).to eq("Auftritt #3")
      expect(parsed_response[1]["free_seats"]).to eq(3)
    end
  end

  context "fetching on gig" do
    let(:gig) { Gig.create! title: "Gig #1", date: DateTime.new(2013, 2, 1) }
    subject! do
      get api_base_path + "/gigs/#{gig.id}"
    end

    its(:status) { should eq(200) }

    it "should have title and date set" do
      expect(parsed_response["title"]).to eq("Gig #1")
      expect(parsed_response["date"]).to include("2013-02-01")
    end
  end
end
