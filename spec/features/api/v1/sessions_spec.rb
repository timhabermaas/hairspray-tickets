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

      it "returns the logged in user" do
        expect(parsed_response["login"]).to eq("hans")
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

  describe "getting the session" do

    context "when logged in" do

      before do
        login_with_name_and_role("peter", :admin)
      end

      subject! do
        get api_base_path + "/sessions/current"
      end

      its(:status) { should eq(200) }

      it "returns the logged in user and its role" do
        expect(parsed_response["login"]).to eq("peter")
        expect(parsed_response["role"]).to eq("admin")
      end

    end

    context "when not logged in" do

      subject! do
        get api_base_path + "/sessions/current"
      end

      its(:status) { should eq(404) }

    end
  end
end
