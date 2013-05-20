module Authorization
  def restrict_access_to(*roles)
    roles_as_parameter_list = roles.map{ |r| "\"#{r}\"" }.join(', ')
    instance_eval <<-EOS
      before do
        account = nil
        if env["rack.session"][:account_id]
          account = Account.find(env["rack.session"][:account_id])
        end
        if account and account.role?(#{roles_as_parameter_list})
          #return
        else
          error!({error: "not authorized"}, 401)
        end
      end
    EOS
  end
end
