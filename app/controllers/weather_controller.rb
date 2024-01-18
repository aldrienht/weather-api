class WeatherController < ApplicationController
  def show
    # For further development, we can respond based on request format, e.g respond_to do |format| ...
    city = params[:city]

    # Start a custom span to measure the duration of weather data request
    OpenTelemetry.tracer_provider.tracer('weather_api').in_span('weather_request') do |span|
      span.set_attribute('city', city)

      if city.blank?
        render json: { error: 'City parameter is required' }, status: :unprocessable_entity
      else
        begin
          weather_info = GetWeatherInfo.call(city)
          render json: weather_info
        rescue StandardError => e
          span.record_exception(e)

          Rails.logger.error("Error fetching weather information for #{city}: #{e.message}")
          render json: { error: 'Failed to fetch weather information' }, status: :internal_server_error
        end
      end
    end
  end
end
