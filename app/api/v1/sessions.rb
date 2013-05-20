class API::V1::Sessions < Grape::API
  resource :sessions do

    desc "Create a new session."
    params do
      requires :login, type: String, desc: "Login"
      requires :password, type: String, desc: "Password"
    end
    post "/", rabl: "account" do
      @account = Account.find_by_login(params["login"]).try(:authenticate, params["password"])
      if @account
        env["rack.session"][:account_id] = @account.id
      else
        env['rack.session'][:account_id] = nil
        error! "login or password doesn't match", 400
      end
    end

    desc "Get the current session."
    get "/current", rabl: "account" do
      begin
        @account = Account.find env["rack.session"][:account_id]
      rescue ActiveRecord::RecordNotFound => e
        env["rack.session"][:account_id] = nil
        error! "no session available", 404
      end
    end

    desc "Deleting current session."
    delete "/current" do
      env["rack.session"][:account_id] = nil
    end
  end
end
