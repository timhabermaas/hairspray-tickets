require "spec_helper"

describe Session do
  describe "#create_with_unique_key!" do
    before do
      Session.create! key: "old_random_key", account_id: 4
    end

    let(:random_generator) { stub(:random_generator) }
    let(:account) { mock_model("Account") }

    context "generated key not yet present" do

      before do
        random_generator.should_receive(:hex).with(42).and_return("1337")
        Session.create_with_unique_key!(account, random_generator)
      end

      it "creates a new Session record" do
        expect(Session.count).to eq(2)
      end

      it "has key set to '1337'" do
        expect(Session.all.map(&:key).sort).to eq(["1337", "old_random_key"].sort)
      end

    end

    context "key already present" do

      before do
        random_generator.should_receive(:hex).twice.and_return("old_random_key", "1337")
        Session.create_with_unique_key!(account, random_generator)
      end

      it "creates a new Session record" do
        expect(Session.count).to eq(2)
      end

      it "has key set to '1337'" do
        expect(Session.all.map(&:key).sort).to eq(["1337", "old_random_key"].sort)
      end

    end
  end
end
