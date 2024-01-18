Rails.application.routes.draw do
  namespace :api do
    get '/get_weather/', to: 'weather#show'
  end

  root "dashboard#index"
end
