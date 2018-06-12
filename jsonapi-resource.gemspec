# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "jsonapi/resource/version"

Gem::Specification.new do |spec|
  spec.name = "jsonapi-resource"
  spec.email = ["pablocrivella@gmail.com", "info@inspire.nl"]
  spec.license = "MIT"
  spec.version = JSONAPI::Resource::VERSION
  spec.authors = ["Pablo Crivella", "InspirenNL"]
  spec.homepage = "https://github.com/InspireNL/jsonapi-resource"

  spec.summary = "Resource classes for APIs implementing the JSON:API spec."

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "jsonapi-client"

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "pry-byebug"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rspec_junit_formatter"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "webmock", "~> 3.0"
end