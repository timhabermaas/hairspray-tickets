require "spec_helper"

describe API::V1::Seats do
  context "fetching seats" do

    let!(:row) { Row.create number: 2, y: 3 }
    let!(:seat_1) { Seat.create number: 4, x: 4, row: row }
    let!(:seat_2) { Seat.create number: 5, x: 5, row: row }

    subject! do
      get api_base_path + "/seats"
    end

    its(:status) { should eq(200) }

    it "returns all seats" do
      expect(parsed_response[0]["number"]).to eq(4)
      expect(parsed_response[0]["row"]["number"]).to eq(2)
      expect(parsed_response[1]["number"]).to eq(5)
    end

  end
end
