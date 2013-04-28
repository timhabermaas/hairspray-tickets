require "spec_helper"

describe Order do
  describe "validations" do
    let(:valid_attributes) { {name: "Hans Mustermann", paid_at: Time.new(2013, 2, 4), reduced_count: 1} }
    let(:valid_order) { Order.new valid_attributes }

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
end