require "spec_helper"

describe Account do
  describe "#role?" do
    it "returns true if account has one of provided roles" do
      expect(Account.new(role: 'user').role?(:user, :admin)).to eq(true)
    end

    it "returns false if account has none of provided roles" do
      expect(Account.new(role: 'user').role?(:moderator, :admin)).to eq(false)
    end
  end
end
