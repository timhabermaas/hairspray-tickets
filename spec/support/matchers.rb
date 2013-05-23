RSpec::Matchers.define :not_be_authorized do
  match do |actual|
    @parsed_body = JSON.parse(actual.body)
    actual.status == 401 and @parsed_body["error"] == "not authorized"
  end

  description do
    'have a 401 status and {"error" => "not authorized"} in its body'
  end

  failure_message_for_should do |actual|
    "expected response to " + description + ", had status #{actual.status} and body #{@parsed_body.inspect.to_s}"
  end
end
