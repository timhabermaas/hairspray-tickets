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
end

RSpec.configure do |c|
  c.include ApiHelper
end
