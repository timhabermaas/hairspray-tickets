require "spec_helper"

describe "/seats" do
  let(:row_1) { Row.create! number: 1, y: 2 }
  let(:row_2) { Row.create! number: 2, y: 4 }

  it "returns nested seats" do
    Seat.create! row: row_1, number: 1, x: 0
    Seat.create! row: row_1, number: 2, x: 1
    Seat.create! row: row_1, number: 3, x: 2
    Seat.create! row: row_2, number: 2, x: 0

    get "/api/seats.json"
    response = JSON.parse(last_response.body)
    p response

    expect(response[1]["y"]).to eq(4)
    expect(response[0]["seats"][1]["number"]).to eq(2)
    expect(response[0]["seats"][2]["number"]).to eq(3)
  end
end
