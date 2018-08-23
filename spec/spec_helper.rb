# frozen_string_literal: true

require "simplecov"
SimpleCov.start

require "bundler/setup"
require "jsonapi-resource"
require "pry"
require "pry-byebug"
require "webmock/rspec"

require "support/base"
require "support/profile"
require "support/post"
require "support/blog_post"
require "support/user"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
