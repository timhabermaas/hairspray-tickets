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

    describe "seats may only be reserved once" do
      let(:seat_1) { FactoryGirl.create :seat }
      let(:seat_2) { FactoryGirl.create :seat }
      let(:seat_3) { FactoryGirl.create :seat }
      let(:gig_1) { FactoryGirl.create :gig }
      let(:gig_2) { FactoryGirl.create :gig }

      before do
        FactoryGirl.create :order, :seats => [seat_1, seat_2], :gig => gig_1
      end

      context "new record" do
        subject { FactoryGirl.build :order, :seats => [seat_1], :gig => gig_1 }

        it "may only reserve each seat once" do
          expect(subject).to_not be_valid
          expect(subject.errors[:seats]).to_not be_blank
        end
      end

      context "old record" do
        subject { FactoryGirl.create :order, :seats => [seat_3], :gig => gig_1 }

        it "let's you still update orders" do
          subject.name = "Peter"
          expect(subject).to be_valid
        end
      end

      context "different gig" do
        subject { FactoryGirl.build :order, :seats => [seat_1], :gig => gig_2 }

        it "is valid" do
          expect(subject).to be_valid
        end
      end
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

  describe "costs" do
    it "returns" do
      order = Order.new
      order.stub(reduced_count: 1)
      order.stub(seats: [stub] * 3)
      expect(order.costs(15, 12)).to eq(42)
    end
  end
end
