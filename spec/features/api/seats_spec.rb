require "spec_helper"

describe "/api/seats" do
  let(:row_1) { Row.create! number: 1, y: 2 }
  let(:row_2) { Row.create! number: 2, y: 4 }

  it "returns nested seats" do
    Seat.create! row: row_1, number: 1, x: 0
    Seat.create! row: row_1, number: 2, x: 1
    Seat.create! row: row_1, number: 3, x: 2
    Seat.create! row: row_2, number: 2, x: 0

    get "/api/seats.json"
    response = JSON.parse(last_response.body)

    seat_numbers = response.map { |s| s["number"] }.sort
    expect(seat_numbers).to eq([1, 2, 2, 3])

    rows = response.map { |s| s["row"]["number"] }.uniq.sort
    expect(rows).to eq([1, 2])
  end
end
