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

    expect(response[0]["number"]).to eq(1)
    expect(response[0]["x"]).to eq(0)

    expect(response[3]["number"]).to eq(2)
    expect(response[3]["x"]).to eq(0)

    expect(response[1]["row"]["number"]).to eq(1)
  end
end
