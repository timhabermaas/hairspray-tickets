module Authorization
  module Helpers
    def authorized?(*roles)
      return false unless env["rack.session"][:account_id]

      account = Account.find(env["rack.session"][:account_id])

      return account && account.role?(*roles)
    end

    def authorize!(*roles)
      if !authorized?(*roles)
        error!({error: "not authorized"}, 401)
      end
    end
  end
end
