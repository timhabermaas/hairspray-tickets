require 'active_record/validations'

class API::V1::Accounts < API::Base
  helpers Authorization::Helpers

  resource :accounts do

    before { authorize!(:admin) }

    rescue_from ActiveRecord::RecordInvalid do |e|
      rack_response({error: e.to_s}.to_json, 400)
    end

    desc "Fetch all accounts."
    get "/", rabl: "accounts" do
      @accounts = Account.all
    end

    desc "Create an account."
    params do
      requires :login, type: String, desc: "Login"
      requires :password, type: String, desc: "Password"
      requires :password_confirmation, type: String, desc: "Confirmation of password"
    end
    post "/", rabl: "account" do
      @account = Account.create! declared(params)
    end

  end
end
