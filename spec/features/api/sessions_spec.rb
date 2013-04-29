require "spec_helper"

describe "sessions" do
  describe "POST /api/sessions" do
    before do
      Rails.application.config.should_receive(:credentials).and_return({name: "Hans", password: "hans"})
    end

    context "credentials match" do
      let(:credentials) { {name: "Hans", password: "hans"} }

      it "responds with success if name matches password" do
        post "api/sessions", credentials
        expect(last_response.headers["Set-Cookie"]).to include("logged_in=true")
        expect(parsed_response["logged_in"]).to eq(true)
      end
    end

    context "credentials do not match" do
      let(:credentials) { {name: "Hans", password: "Hans"} }

      it "responds with 400" do
        post "api/sessions", credentials

        expect(last_response.status).to eq(400)
        expect(last_response.headers["Set-Cookie"]).to include("logged_in=false")
        expect(parsed_response["logged_in"]).to eq(false)
      end
    end
  end
end
