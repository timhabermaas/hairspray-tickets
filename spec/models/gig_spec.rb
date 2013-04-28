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
      Seat.should_receive(:usuable_count).and_return(20)
      subject.should_receive(:orders).and_return orders
      expect(subject.free_seats).to eq(6)
    end
  end
end
