# Project: Simple Weather API and Monitoring Integration

This is a simple Weather API application made using Ruby on Rails with OpenWeatherMap API.
The purpose of this app is to quickly get the weather information of specific "city" around the world.

Beyond the basic use case of retrieving weather information for a specific city, your simple Weather API can be utilized for various purposes. Here are some additional use cases:
  1. Weather Notifications
    Provide users with the ability to subscribe to weather notifications for specific cities. Notifications can be sent via email, mobile push notifications, or even SMS.
  2. Weather Widgets
    Create widgets that users can embed on their websites or applications to display real-time weather information for a chosen city.
  3. Weather Forecasting
    Extend your API to provide weather forecasts for the upcoming days, enabling users to plan activities based on expected weather conditions.
  4. Travel Planning
    Integrate the API into travel planning apps, helping users make informed decisions about their destination based on the current and forecasted weather.
  5. Event Planning
    Assist event organizers in planning outdoor events by providing weather information. This can help in deciding the date, time, and necessary preparations.
  6. Agriculture and Farming
    Farmers can use weather data to make informed decisions about planting, harvesting, and irrigation schedules, optimizing agricultural practices.
  7. Health and Wellness
    Integrate weather information into health and wellness apps to provide users with personalized recommendations based on weather conditions, such as outdoor exercise suggestions.


# API endpoint

  Path: "/api/get_weather"

  Request Format: JSON

  Required Parameter: "city"

    > Example: "/api/get_weather.json?city=Manila"

    > Result: JSON data


# How to run the app locally

If you already set up your local Rails environment continue on this step, otherwise please see instructions on how to set up local Rails environment.

1. Navigate to your project directory (/weather_api) and install the required gems:
  bundle install
2. See guide on "How to add environment variables"
3. Start the Rails server:
  rails server
4. Access the Application:
  Open your web browser and navigate to http://localhost:3000. You should see your Rails application running.
5. Get weather information for specific "city"

  Navigate to /get_weather path and pass the "city" as parameter to get the Weather info.

  Example: http://localhost:3000/get_weather?city=Manila 


# How to add environment variables to App

  In your app directory, create a file named ".env" and supply your own values for the following keys:

    • OPENWEATHERMAP_API_KEY=add-api-key-here
      > Sign up for free in https://openweathermap.org

      > Navigate to https://home.openweathermap.org/api_keys to generate/get your API Key

      > Screenshot here: http://tinyurl.com/yr55uub5

    • UPTRACE_DSN=https://sample-only-add-your-own@api.uptrace.dev?grpc=4317
      > Sign up or login to Uptrace https://app.uptrace.dev/auth/login

      > Once logged-in create an Uptrace project to obtain a DSN (connection string), for example, https://token@api.uptrace.dev/project_id.

      > Screenshot here: http://tinyurl.com/yqj29jcq


# How to set up your local Rails environment
Prerequisites:
  1. Make sure you have Ruby and RubyGems installed on your machine. You can check this by running:
    ruby -v
    gem -v
  2. Install Rails using the following command:
    gem install rails
  3. Navigate to your project directory (/weather_api) and install the required gems:
    bundle install
  4. See guide on "How to add environment variables"
  5. Start the Rails server:
    rails server
  6. Access the Application:
    Open your web browser and navigate to http://localhost:3000. You should see your Rails application running.
  7. Get weather information for specific "city"
    Navigate to /get_weather path and pass the "city" as parameter to get the Weather info.
    Example: http://localhost:3000/api/get_weather.json?city=manila


# Visit Uptrace Dashboard to see metrics
  • When you already signed up and logged in to Uptrace, choose your created Project and navigate to pages like
  Overview, Traces & Log, Dashboards, Compare etc... to see full generated metrics.

  Sample Screenshots:

  - http://tinyurl.com/yscxwqno
  - http://tinyurl.com/yukhua6x
  - http://tinyurl.com/yukhua6x


# Suggestions for improvement
• Authentication and Authorization

  If our API is meant for public consumption, let's consider implementing API key authentication for better security. If it's intended for internal use, set up proper user authentication and authorization.

• Rate Limiting

  Implement rate limiting to prevent abuse of your API. This helps control the number of requests a user can make within a specific time frame.

    Option #1: Use a Gem
      Consider using a gem that provides rate limiting functionality. One popular gem is rack-attack. It allows you to define custom throttles for different routes and actions in your Rails application.

    Option #2: Store Data for Rate Limiting
      Use a data store to keep track of request counts, such as Redis or a database.

    Option #3: Response Headers
      Include rate limit information in your response headers to provide clients with details about their remaining requests and reset times. These headers allows the client to adjust its behavior based on the rate limit information.

• Refactor Code:

  Review the codebase for opportunities to refactor and improve code quality.

• Unit and Integration Testing

  Expand our test suite to cover more scenarios. Ensure that both unit tests and integration tests are comprehensive, covering various edge cases and potential issues.

• Extend Functionality

  Explore adding more features to our API, such as historical weather data, multiple city queries, or support for different weather providers.

• Scalability

  Design our application with scalability in mind. Monitor and plan for potential increases in traffic.

  For example:

    * Implement caching mechanisms for API responses
    
    * Cloud Auto-Scaling - Utilize cloud provider services for auto-scaling, allowing the infrastructure to dynamically adjust based on demand.
