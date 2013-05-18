class API::V1::Sessions < Grape::API
  resource :sessions do

    desc "Create a new session."
    params do
      requires :login, type: String, desc: "Login"
      requires :password, type: String, desc: "Password"
    end
    post "/" do
      account = Account.find_by_login(params["login"]).try(:authenticate, params["password"])
      if account
        session = Session.create_with_unique_key!(account)
        {session_key: session.key}
      else
        error! "login or password doesn't match", 400
      end
    end

  end
end
