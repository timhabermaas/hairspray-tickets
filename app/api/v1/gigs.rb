class API::V1::Gigs < Grape::API
  formatter :json, Grape::Formatter::Rabl

  resource :gigs do
    get "/", :rabl => "gigs" do
      @gigs = Gig.all
    end

    namespace ":id" do
      get "/" do
        Gig.find params[:id]
      end
    end
  end
end