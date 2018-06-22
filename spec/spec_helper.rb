# frozen_string_literal: true

require "simplecov"
SimpleCov.start

require "bundler/setup"
require "jsonapi-resource"
require "pry"
require "pry-byebug"
require "webmock/rspec"

class Base < JSONAPI::Resource::Base
  def self.base_uri
    "https://api.example.com"
  end
end

class Profile < Base
  self.type = "profiles"

  resource_attribute :first_name, JSONAPI::Types::String
  resource_attribute :last_name, JSONAPI::Types::String
end

class Post < Base
  self.type = "posts"

  resource_attribute :title, JSONAPI::Types::String, updatable: false
  resource_attribute :body, JSONAPI::Types::String, creatable: false
end

class BlogPost < Post
  self.type = "blog_posts"

  resource_attribute :blog_name, JSONAPI::Types::String
end

class User < Base
  self.type = "users"

  resource_attribute :email, JSONAPI::Types::String

  relationship_to_many :posts, class_name: "Post"
  relationship_to_one :profile, class_name: "Profile"
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
