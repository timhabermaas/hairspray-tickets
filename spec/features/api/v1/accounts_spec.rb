require "spec_helper"

describe API::V1::Accounts do

  context "when logged in as admin" do

    before(:all) do
      login_with_name_and_role("hans", :admin)
    end

    after(:all) do
      Account.delete_all
    end

    describe "fetching accounts" do

      let!(:account_1) { FactoryGirl.create :account, login: "abcd" }
      let!(:account_2) { FactoryGirl.create :account, login: "ufo" }

      subject! do
        get api_base_path + "/accounts"
      end

      its(:status) { should eq(200) }

      it "returns all accounts" do
        expect(parsed_response).to have(3).items # includes the user itself
        expect(parsed_response[0]["login"]).to eq("hans")
        expect(parsed_response[1]["login"]).to eq("abcd")
        expect(parsed_response[2]["login"]).to eq("ufo")
        expect(parsed_response[0]["role"]).to eq("admin")
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

        let(:parameters) { {login: "alfred", password: "secret", password_confirmation: "secret", role: "admin"} }

        its(:status) { should eq(201) }

        it "creates an account" do
          expect(Account.count).to eq(2)
          expect(Account.last.login).to eq("alfred")
          expect(Account.last.role).to eq("admin")
        end

        it "returns the new account" do
          expect(parsed_response["login"]).to eq("alfred")
          expect(parsed_response["role"]).to eq("admin")
        end

        it "doesn't return the password" do
          expect(parsed_response["password"]).to be_nil
          expect(parsed_response["password_confirmation"]).to be_nil
          expect(parsed_response["password_digest"]).to be_nil
        end

      end

      context "missing paramater" do

        let(:parameters) { {password: "secret", password_confirmation: "secret"} }

        its(:status) { should eq(400) }

        it "returns the error" do
          expect(parsed_response["error"]).to eq("missing parameter: login")
        end

      end

      context "password not confirmed" do

        let(:parameters) { {login: "alfred", password: "secret", password_confirmation: "secret2", role: "user"} }

        its(:status) { should eq(400) }

        it "returns the error" do
          expect(parsed_response["error"]).to eq("Validation failed: Password doesn't match confirmation")
        end

      end
    end

    describe "removing of account" do

      let(:account) { FactoryGirl.create :account, login: "muh" }

      subject! do
        delete api_base_path + "/accounts/#{account.id}"
      end

      its(:status) { should eq(200) }

      it "should remove the account" do
        expect(Account.find_by_id(account.id)).to be_nil
      end
    end
  end

  context "when logged in as user" do

    before(:all) do
      login_with_name_and_role("hans", :user)
    end

    after(:all) do
      Account.delete_all
    end

    context "fetching accounts" do

      subject! do
        get api_base_path + "/accounts"
      end

      it { should not_be_authorized }

    end

    context "creating an account" do

      subject! do
        get api_base_path + "/accounts"
      end

      it { should not_be_authorized }

    end
  end

  context "when not logged in" do

    context "fetching accounts" do

      subject! do
        get api_base_path + "/accounts"
      end

      it { should not_be_authorized }

    end

    context "creating an account" do

      subject! do
        get api_base_path + "/accounts"
      end

      it { should not_be_authorized }

    end
  end
end
