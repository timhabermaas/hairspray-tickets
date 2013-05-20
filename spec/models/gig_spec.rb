require "spec_helper"

describe Gig do
  describe "validations" do
    let(:valid_attributes) { {title: "Gig #1", date: Time.new(2013, 4, 5)} }
    subject { Gig.new valid_attributes }

    it "requires a title" do
      subject.title = ""
      expect(subject).to_not be_valid
      expect(subject.errors[:title]).to_not be_blank
    end

    it "requires a date" do
      subject.date = ""
      expect(subject).to_not be_valid
      expect(subject.errors[:date]).to_not be_blank
    end
  end

  describe "#free_seats" do
    let(:orders) { [stub(:order, :seats_count => 4),
                    stub(:order, :seats_count => 10)] }

    it "returns 6 if two orders have reserved 4 and 10 seats respectively" do
      Seat.should_receive(:usable_count).and_return(20)
      subject.should_receive(:orders).and_return orders
      expect(subject.free_seats).to eq(6)
    end
  end

  describe "#prev_gig" do
    let!(:gig) { FactoryGirl.create :gig, date: DateTime.new(2013, 3) }

    context "has previous gig" do
      let!(:prev_gig) { FactoryGirl.create :gig, date: DateTime.new(2013, 2) }
      let!(:prev_gig_2) { FactoryGirl.create :gig, date: DateTime.new(2013, 1) }

      it "returns the previous gig" do
        expect(gig.prev_gig).to eq(prev_gig)
      end
    end

    context "has no previous gig" do
      it "returns nil" do
        expect(gig.prev_gig).to be_nil
      end
    end
  end

  describe "#next_gig" do
    let!(:gig) { FactoryGirl.create :gig, date: DateTime.new(2013, 2) }

    context "has next gig" do
      let!(:next_gig) { FactoryGirl.create :gig, date: DateTime.new(2013, 3) }
      let!(:next_gig2) { FactoryGirl.create :gig, date: DateTime.new(2013, 4) }

      it "returns the next gig" do
        expect(gig.next_gig).to eq(next_gig)
      end
    end

    context "has no next gig" do
      it "returns nil" do
        expect(gig.next_gig).to be_nil
      end
    end
  end
end
