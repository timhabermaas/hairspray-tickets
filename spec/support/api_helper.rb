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

  def create_valid_api_key_for(role)
    account = FactoryGirl.create :account, role: role
    Session.create_with_unique_key!(account).key
  end
end

RSpec.configure do |c|
  c.include ApiHelper
end
