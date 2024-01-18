require 'rails_helper'
require 'webmock/rspec'

RSpec.describe GetWeatherInfo, type: :service do
  let(:test_city) { "Manila" }
  let(:api_key) { ENV['OPENWEATHERMAP_API_KEY'] }

  describe ".call" do
    context "when the API request is successful" do
      before do
        # Stubbing the HTTP requests for a successful response
        base_url = 'https://api.openweathermap.org/data/2.5/weather'
        query_params = { q: test_city, appid: api_key, units: 'metric' }

        stub_request(:get, base_url).with(query: query_params).to_return(
          status: 200,
          body: '{
            "coord": {"lon": 120.9822, "lat": 14.6042},
            "main": {"temp": 25.33, "feels_like": 25.88, "humidity": 75},
            "weather": [{"id": 804, "main": "Clouds", "description": "overcast clouds", "icon": "04n"}],
            "wind": {"speed": 0.45, "deg": 34},
            "sys": {"country": "PH"},
            "name": "Manila"
          }',
          headers: { 'Content-Type' => 'application/json' }
        )

        # Stubbing the HTTP requests for a 404 response (nonexistent city)
        stub_request(:get, base_url).with(query: { q: 'nonexistentcity', appid: api_key, units: 'metric' }).to_return(
          status: 404,
          body: '{"error":"city not found"}',
          headers: { 'Content-Type' => 'application/json' }
        )
      end

      it 'returns weather data for a valid city' do
        weather_info = GetWeatherInfo.new(test_city).perform
        expected_result = {
          'coord' => {'lon' => 120.9822, 'lat' => 14.6042},
          'main' => {'temp' => 25.33, 'feels_like' => 25.88, 'humidity' => 75},
          'weather' => [{'id' => 804, 'main' => 'Clouds', 'description' => 'overcast clouds', 'icon' => '04n'}],
          'wind' => {'speed' => 0.45, 'deg' => 34},
          'sys' => {'country' => 'PH'},
          'name' => 'Manila'
        }
        expect(weather_info).to eq(expected_result)
      end

      it 'returns an error for an invalid city' do
        weather_info = GetWeatherInfo.call('nonexistentcity')
        expect(weather_info).to eq({:cod=>"404", :error=>"Failed to fetch weather data for city: nonexistentcity"})
      end
    end

    context "when the API request fails" do
      before do
        stub_request(:get, /api\.openweathermap\.org\/data\/2\.5\/weather/).
          with(query: { q: test_city, appid: api_key, units: 'metric' }).
          to_return(status: 500)
      end

      it "returns an error response for a failed request" do
        result = described_class.call(test_city)
        expect(result).to eq({:cod=>"404", :error=>"Failed to fetch weather data for city: #{test_city}"})
      end
    end
  end
end
