require 'uptrace'
require 'opentelemetry-instrumentation-rails'

class InitUptrace < ApplicationService
  def perform
    Uptrace.configure_opentelemetry(dsn: ENV['UPTRACE_DSN']) do |c|
      c.use 'OpenTelemetry::Instrumentation::Rails'
      c.service_name = 'myservice'
      c.service_version = '1.0.0'
      c.resource = OpenTelemetry::SDK::Resources::Resource.create(
        'deployment.environment' => 'development'
      )
    end
  end
end
