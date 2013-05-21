HairsprayTickets::Application.routes.draw do
  root to: "main#index"

  get "/templates/:path.html" => "templates#file", :constraints => { :path => /.+/ }

  mount API::V1::Root => "/api"

  mount JasmineRails::Engine => "/specs" if Rails.env.development?
end
