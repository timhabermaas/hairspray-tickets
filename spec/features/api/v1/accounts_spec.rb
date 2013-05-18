require "spec_helper"

#Rails.application.reload_routes!

describe API::V1::Accounts do
  describe "fetching accounts" do
    let!(:account_1) { FactoryGirl.create :account, login: "abcd", email: "muh@cow.com" }
    let!(:account_2) { FactoryGirl.create :account, login: "ufo" }

    subject! do
      get api_base_path + "/accounts"
    end

    its(:status) { should eq(200) }

    it "returns all accounts" do
      expect(parsed_response[0]["login"]).to eq("abcd")
      expect(parsed_response[1]["login"]).to eq("ufo")
      expect(parsed_response[0]["email"]).to eq("muh@cow.com")
    end

    it "doesn't return a password" do
      expect(parsed_response[0]["password"]).to be_nil
      expect(parsed_response[0]["password_digest"]).to be_nil
      expect(parsed_response[1]["password"]).to be_nil
      expect(parsed_response[1]["password_digest"]).to be_nil
    end
  end

  describe "creating an account" do

    subject! do
      post api_base_path + "/accounts", parameters
    end

    context "valid parameters" do

      let(:parameters) { {login: "alfred", email: "muh@cow.com", password: "secret", password_confirmation: "secret"} }

      its(:status) { should eq(201) }

      it "creates an account" do
        expect(Account.count).to eq(1)
        expect(Account.first.login).to eq("alfred")
      end

      it "returns the new account" do
        expect(parsed_response["login"]).to eq("alfred")
      end

      it "doesn't return the password" do
        expect(parsed_response["password"]).to be_nil
        expect(parsed_response["password_confirmation"]).to be_nil
        expect(parsed_response["password_digest"]).to be_nil
      end

    end

    context "missing paramater" do

      let(:parameters) { {login: "alfred", password: "secret", password_confirmation: "secret"} }

      its(:status) { should eq(400) }

      it "returns the error" do
        expect(parsed_response["error"]).to eq("missing parameter: email")
      end

    end

    context "password not confirmed" do

      let(:parameters) { {login: "alfred", email: "muh@cow.com", password: "secret", password_confirmation: "secret2"} }

      its(:status) { should eq(400) }

      it "returns the error" do
        expect(parsed_response["error"]).to eq("Validation failed: Password doesn't match confirmation")
      end

    end
  end
end
