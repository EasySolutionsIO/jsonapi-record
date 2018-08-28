# frozen_string_literal: true

module JSONAPI
  module Record
    module Queryable
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        # @param id [String]
        # @param query [Hash]
        # @raise [JSONAPI::Client::NotFound] if resource doesn't exist.
        def find!(id, query = {})
          fetch_resource(individual_uri(id), query)
        end

        # @param id [String]
        # @param query [Hash]
        # @return [nil] if resource doesn't exits.
        # @return [JSONAPI::Record::Base]
        def find(id, query = {})
          find!(id, query)
        rescue JSONAPI::Client::NotFound
          nil
        end

        # @param query [Hash]
        # @return [Array<JSONAPI::Record::Base>]
        def all(query = {})
          fetch_collection(collection_uri, query)
        end
      end
    end
  end
end
