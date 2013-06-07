require "spec_helper"

describe Reservation do
  describe "validations" do
    let(:subject) { Reservation.new order_id: 2, seat_id: 4 }

    it "can save valid reservations" do
      expect(subject).to be_valid
    end

    it "requires order_id to be present" do
      subject.order_id = nil
      expect(subject).to_not be_valid
      expect(subject.errors[:order_id]).to_not be_blank
    end

    it "requires seat_id to be present" do
      subject.seat_id = nil
      expect(subject).to_not be_valid
      expect(subject.errors[:seat_id]).to_not be_blank
    end
  end
end
