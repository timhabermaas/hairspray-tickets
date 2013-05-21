class API::V1::Seats < API::Base
  resource :seats do

    desc "Fetches all seats."
    get "/", rabl: "seats" do
      @seats = Seat.includes(:row)
    end

  end
end
