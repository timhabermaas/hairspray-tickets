require "spec_helper"

describe Reservation do
  describe "callbacks" do
    let(:order) { mock_model("Order", gig_id: 42) }
    let(:subject) { Reservation.new order: order }

    it "sets gig_id to order's gig_id before validation" do
      subject.valid?
      expect(subject.gig_id).to eq(42)
    end
  end

  describe "validations" do
    let(:subject) { Reservation.new order_id: 2, seat_id: 4, gig_id: 10 }

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

    it "requires gig_id to be present" do
      subject.gig_id = nil
      expect(subject).to_not be_valid
      expect(subject.errors[:gig_id]).to_not be_blank
    end
  end
end
