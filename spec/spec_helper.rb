# frozen_string_literal: true

require "caiena_openweathermap_sdk"

require "webmock/rspec"

# Ensure all /lib files are loaded
# so they will be included in the test coverage report.
Dir["./lib/**/*.rb"].each { |file| require file }

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
