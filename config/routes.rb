Rails.application.routes.draw do
  get '/get_weather', to: 'weather#show'
  root "weather#index"
end
