HairsprayTickets::Application.routes.draw do
  root to: "main#index"

  get "/templates/:path.html" => "templates#file", :constraints => { :path => /.+/ }

  namespace :api do
    resources :sessions, :only => [:create]
    resources :seats
    resources :gigs do
      resources :orders do
        post :pay, :on => :member
        post :unpay, :on => :member
      end
    end
  end

  mount JasmineRails::Engine => "/specs" if Rails.env.development?
end
