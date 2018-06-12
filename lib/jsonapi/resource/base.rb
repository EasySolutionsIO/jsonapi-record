# frozen_string_literal: true

module JSONAPI
  module Resource
    class Base < Struct
      include JSONAPI::Resource::Attributes
      include JSONAPI::Resource::Relationships
      include JSONAPI::Resource::Errors
      include JSONAPI::Resource::Persistence
      include JSONAPI::Resource::Querying
      include JSONAPI::Resource::URIs

      attribute :id, Types::String
      attribute :meta, JSONAPI::Types::Meta
      attribute :links, JSONAPI::Types::Links
      attribute :relationships, JSONAPI::Types::Relationships
      attribute :top_level_links, JSONAPI::Types::Links
      attribute :top_level_meta, JSONAPI::Types::Meta
      attribute :response_errors, JSONAPI::Types::Array(JSONAPI::Types::Error)
      attribute :persisted, Types::Bool.default(false)

      class << self
        attr_accessor :type

        def default_headers
          {}
        end

        def parse(document)
          JSONAPI::Resource::Parser.parse(document)
        end
      end
    end
  end
end
