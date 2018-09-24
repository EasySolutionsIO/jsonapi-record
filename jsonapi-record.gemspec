# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "jsonapi/record/version"

Gem::Specification.new do |spec|
  spec.name = "jsonapi-record"
  spec.email = ["pablocrivella@gmail.com", "info@inspire.nl"]
  spec.license = "MIT"
  spec.version = JSONAPI::Record::VERSION
  spec.authors = ["Pablo Crivella", "InspirenNL"]
  spec.homepage = "https://github.com/InspireNL/jsonapi-record"
  spec.summary = "Base classes for APIs implementing the JSON:API spec."
  spec.metadata = {
    "bug_tracker_uri" => "https://github.com/InspireNL/jsonapi-record/issues",
    "changelog_uri"   => "https://github.com/InspireNL/jsonapi-record/blob/master/CHANGELOG.md",
    "source_code_uri" => "https://github.com/InspireNL/jsonapi-record"
  }
  spec.files = Dir["lib/**/*"]
  spec.extra_rdoc_files = Dir["README*", "LICENSE*"]
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "jsonapi-client"

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "pry", "~> 0.11"
  spec.add_development_dependency "pry-byebug", "~> 3.6"
  spec.add_development_dependency "rake", "~> 12.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rspec_junit_formatter", "~> 0.4"
  spec.add_development_dependency "rubocop", "~> 0.59"
  spec.add_development_dependency "rubocop-rspec", "~> 1.29"
  spec.add_development_dependency "simplecov", "~> 0.16"
  spec.add_development_dependency "webmock", "~> 3.0"
end
