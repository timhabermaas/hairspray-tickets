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
    let(:reservations) { [stub(:reservation)] * 14 }

    it "returns 6 if 14 seats have been reserved and 20 seats are usable" do
      Seat.stub(:usable_count => 20)
      subject.stub(:reservations => reservations)
      expect(subject.free_seats).to eq(6)
    end
  end
end
