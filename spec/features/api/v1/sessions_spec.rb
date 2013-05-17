require "spec_helper"

describe API::V1::Sessions do

  describe "creating a session" do

    let!(:account) { FactoryGirl.create :account, login: "hans", password: "secret" }

    subject! do
      post api_base_path + "/sessions", parameters
    end

    context "matching login details" do

      let(:parameters) { {login: "hans", password: "secret"} }

      its(:status) { should eq(201) }

      it "returns a session key" do
        expect(parsed_response["session_key"]).to be_present
        parsed_response["session_key"].length.should be > 20
      end

      it "creates a new session key for the account" do
        expect(account.reload.sessions.last.key).to eq(parsed_response["session_key"])
      end

    end

    context "login details don't match" do

      let(:parameters) { {login: "hans", password: "secret_wrong"} }

      its(:status) { should eq(400) }

      it "returns 'login or password doesn't match'" do
        expect(parsed_response["error"]).to eq("login or password doesn't match")
      end

    end
  end
end
