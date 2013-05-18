module Authorization
  def restrict_access_to(role)
    instance_eval <<-EOS
      before do
        session = Session.find_by_key(headers["X-Api-Key"])
        if session and session.account and session.account.role?("#{role}")
          #return
        else
          error!({error: "not authorized"}, 401)
        end
      end
    EOS
  end
end
