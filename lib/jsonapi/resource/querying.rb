# frozen_string_literal: true

module JSONAPI
  module Resource
    module Querying
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        def fetch(uri, query = {})
          parse(JSONAPI::Client.fetch(uri, default_headers, query))
        end

        def fetch_resource(uri, query = {})
          new(fetch(uri, query))
        end

        def fetch_collection(uri, query = {})
          fetch(uri, query).map { |attributes| new(attributes) }
        end

        def find!(id, query = {})
          fetch_resource(individual_uri(id), query)
        end

        def find(id, query = {})
          find!(id, query)
        rescue JSONAPI::Client::NotFound
          nil
        end

        def all(query = {})
          fetch_collection(collection_uri, query)
        end
      end
    end
  end
end
