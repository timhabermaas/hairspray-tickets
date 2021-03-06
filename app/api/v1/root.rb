class API::V1::Root < API::Base
  version "v1", using: :path
  format :json
  formatter :json, Grape::Formatter::Rabl

  mount API::V1::Gigs
  mount API::V1::Orders
  mount API::V1::Seats
  mount API::V1::Accounts
  mount API::V1::Sessions
end
