Rails.application.configure do
# Rails.application.config.to_prepare do
  require 'uptrace'
  require 'opentelemetry-instrumentation-rails'

  # Configure OpenTelemetry with sensible defaults.
  # Copy your project DSN here or use UPTRACE_DSN env var.
  Uptrace.configure_opentelemetry(dsn: ENV['UPTRACE_DSN']) do |c|
    # c is OpenTelemetry::SDK::Configurator
    c.use_all
    c.service_name = 'weather_api_service'
    c.service_version = '1.0.0'

    c.resource = OpenTelemetry::SDK::Resources::Resource.create(
      'deployment.environment' => 'production'
    )
  end

  # Create a tracer. Usually, tracer is a global variable.
  tracer = OpenTelemetry.tracer_provider.tracer('weather_api', '0.1.0')

  # Create a root span (a trace) to measure some operation.
  tracer.in_span('main-operation', kind: :client) do |main|
    tracer.in_span('GET /get_weather') do |child1|
      child1.set_attribute('http.method', 'GET')
      child1.set_attribute('http.route', '/get_weather')
      child1.set_attribute('http.url', 'http://localhost:3080/get_weather')
      child1.set_attribute('http.status_code', 200)
      child1.record_exception(ArgumentError.new('error1'))
    end

    puts("Uptrace URL: #{Uptrace.trace_url(main)}")
  end

  # Send buffered spans and free resources.
  OpenTelemetry.tracer_provider.shutdown
end
