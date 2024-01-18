class Api::WeatherController < ApplicationController
  before_action :ensure_json_format

  def show
    city = params[:city]

    InitUptrace.call

    tracer = OpenTelemetry.tracer_provider.tracer('weather_api')
    root_span = tracer.start_root_span('searched_cities')
    root_span.set_attribute('city', city)
    root_span.add_event('api searches')

    respond_to do |format|
      format.json do
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
          ensure
            root_span.finish
            OpenTelemetry.tracer_provider.shutdown unless Rails.env.test?
          end
        end
      end
    end
  end

  private

  def ensure_json_format
    render json: { error: 'Unsupported format' }, status: :not_acceptable unless request.format.json?
  end

  def measure_time
    start_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    result = yield
    end_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    duration_ms = ((end_time - start_time) * 1000).round(2)
    { data: result, duration_ms: duration_ms }
  end
end
