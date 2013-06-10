require "spec_helper"

describe Order do
  let(:valid_attributes) { FactoryGirl.attributes_for(:order) }
  let(:valid_order) { Order.new valid_attributes }

  describe "validations" do
    it "is valid" do
      expect(valid_order).to be_valid
    end

    it "requires a name" do
      valid_order.name = ""
      expect(valid_order).to_not be_valid
      expect(valid_order.errors[:name]).to_not be_blank
    end

    it "can't have more reduced seats than total seats" do
      valid_order.stub(seats: [:stub, :stub])
      valid_order.reduced_count = 3
      expect(valid_order).to_not be_valid
      expect(valid_order.errors[:reduced_count]).to_not be_blank
    end

    it "can't have a negative count of reduced seats" do
      valid_order.reduced_count = -1
      expect(valid_order).to_not be_valid
      expect(valid_order.errors[:reduced_count]).to_not be_blank
    end

    it "requires at least one reserved seat" do
      valid_order.seats = []
      expect(valid_order).to_not be_valid
      expect(valid_order.errors[:seats]).to_not be_blank
    end
  end

  describe "#pay!" do
    let(:order) { Order.create! valid_attributes.merge(paid_at: nil) }

    it "pays order and saves it" do
      order.pay!
      expect(order.reload).to be_paid
    end
  end

  describe "#unpay!" do
    let(:order) { Order.create! valid_attributes.merge(paid_at: DateTime.now) }

    it "unpays order and saves it" do
      order.unpay!
      expect(order.reload).to_not be_paid
    end
  end

  describe "#costs" do
    it "returns the total costs the customer has to pay" do
      order = Order.new
      order.stub(reduced_count: 1)
      order.stub(seats: [stub] * 3)
      expect(order.costs(15, 12)).to eq(42)
    end
  end

  describe "#destroy" do
    let!(:order) { FactoryGirl.create :order }

    it "removes all associated reservations when being destroyed" do
      expect {
        order.destroy
      }.to change(Reservation, :count).to(0)
    end
  end
end
