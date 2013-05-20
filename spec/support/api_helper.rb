module ApiHelper
  include Rack::Test::Methods

  def app
    Rails.application
  end

  def parsed_response
    JSON.parse(last_response.body)
  end

  def api_base_path
    "/api/v1"
  end

  def login_with_name_and_role(name, role)
    account = FactoryGirl.create :account, login: name, password: "secret", role: role
    post api_base_path + "/sessions", {login: name, password: "secret"}
  end
end

RSpec.configure do |c|
  c.include ApiHelper
end
