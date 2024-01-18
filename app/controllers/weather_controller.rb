class WeatherController < ApplicationController
  def show
    # For further development, we can respond based on request format, e.g respond_to do |format| format.json ...
    city = params[:city]

    InitUptrace.call

    tracer = OpenTelemetry.tracer_provider.tracer('weather_api')
    root_span = tracer.start_root_span('searched_cities')
    root_span.set_attribute('city', city)
    root_span.add_event('api searches')

    if city.blank?
      render json: { error: 'City parameter is required' }, status: :unprocessable_entity
    else
      begin
        weather_info = measure_time { GetWeatherInfo.call(city) }
        root_span.set_attribute('response_time', weather_info[:duration_ms])

        render json: weather_info[:data]
      rescue StandardError => e
        root_span.record_exception(e)

        Rails.logger.error("Error fetching weather information for #{city}: #{e.message}")
        render json: { error: 'Failed to fetch weather information' }, status: :internal_server_error
      end
    end

    root_span.finish

    # Ensure resources are properly shutdown
    OpenTelemetry.tracer_provider.shutdown unless Rails.env.test?
  end

  private

  def measure_time
    start_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    result = yield
    end_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    duration_ms = ((end_time - start_time) * 1000).round(2)
    { data: result, duration_ms: duration_ms }
  end
end
