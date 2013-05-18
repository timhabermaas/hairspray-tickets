module Authorization
  def restrict_access_to(*roles)
    roles_as_parameter_list = roles.map{ |r| "\"#{r}\"" }.join(', ')
    instance_eval <<-EOS
      before do
        session = Session.find_by_key(headers["X-Api-Key"])
        if session and session.account and session.account.role?(#{roles_as_parameter_list})
          #return
        else
          error!({error: "not authorized"}, 401)
        end
      end
    EOS
  end
end
