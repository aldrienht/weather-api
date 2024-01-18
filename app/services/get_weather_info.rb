class GetWeatherInfo < ApplicationService
  include HTTParty

  attr_reader :city, :api_key

  BASE_URL = 'https://api.openweathermap.org/data/2.5/weather'.freeze

  def initialize(city)
    @city = city
    @api_key = ENV['OPENWEATHERMAP_API_KEY']
  end

  def perform
    response = self.class.get(BASE_URL, query: query_params)
    if response.success?
      response.parsed_response
    else
      { error: "Failed to fetch weather data for city: #{city}", cod: "404" }
    end
  end

  private

  def query_params
    {
      q: city,
      appid: api_key,
      units: 'metric' # change to 'imperial' for Fahrenheit
    }
  end
end
