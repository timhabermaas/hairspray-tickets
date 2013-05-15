require "spec_helper"

describe Order do
  let(:valid_attributes) { {name: "Hans Mustermann", paid_at: Time.new(2013, 2, 4), reduced_count: 0, gig_id: 2} }
  let(:valid_order) { Order.new valid_attributes }

  describe "validations" do
    it "requires a name" do
      valid_order.name = ""
      expect(valid_order).to_not be_valid
      expect(valid_order.errors[:name]).to_not be_blank
    end

    it "can't have more reduced seats than total seats" do
      valid_order.stub(:seats => [:stub, :stub])
      valid_order.reduced_count = 3
      expect(valid_order).to_not be_valid
      expect(valid_order.errors[:reduced_count]).to_not be_blank
    end

    it "can't have a negative count of reduced seats" do
      valid_order.reduced_count = -1
      expect(valid_order).to_not be_valid
      expect(valid_order.errors[:reduced_count]).to_not be_blank
    end
  end

  describe "#seats_count" do
    it "returns the amount of reservations" do
      subject.should_receive(:reservations_count).and_return(45)
      expect(subject.seats_count).to eq(45)
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
end
