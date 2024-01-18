require 'rails_helper'

RSpec.describe Api::WeatherController, type: :controller do
  describe "GET #show" do
    before do
      allow(GetWeatherInfo).to receive(:call).and_return({
        "timezone": 28800,
        "id": 1701668,
        "name": "Manila",
        "cod": 200
      })
    end

    it "renders weather info" do
      get :show, params: {city: "Manila"}, format: :json
      expect(response).to have_http_status(:ok)
      expect(response.content_type).to match(/application\/json/)
    end
  end
end
