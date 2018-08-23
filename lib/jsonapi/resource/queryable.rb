# frozen_string_literal: true

module JSONAPI
  module Resource
    module Queryable
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
