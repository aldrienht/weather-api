require 'rails_helper'

RSpec.describe WeatherController, type: :controller do
  describe "GET #index" do
    it "renders edit page and assigns value" do
      get :index, params: {}, format: :html
      expect(response).to render_template(:index)
    end
  end

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
      get :show, params: {city: "Manila"}, format: :html
      expect(response).to have_http_status(:ok)
      expect(response.content_type).to match(/application\/json/)
    end
  end
end
