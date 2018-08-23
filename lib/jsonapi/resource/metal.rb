# frozen_string_literal: true

module JSONAPI
  module Resource
    class Metal < Dry::Struct #  rubocop:disable Metrics/ClassLength
      # Convert string keys to symbols
      transform_keys(&:to_sym)

      # Resolve default types on nil
      transform_types do |type|
        if type.default?
          type.constructor { |value| value.nil? ? Dry::Types::Undefined : value }
        else
          # Make all types omittable
          type.meta(omittable: true)
        end
      end

      defines :base_uri, :type, :default_headers, :relationship_names

      relationship_names([])
      default_headers({})

      attribute :id, Types::String
      attribute :meta, JSONAPI::Types::Meta
      attribute :links, JSONAPI::Types::Links
      attribute :relationships, JSONAPI::Types::Relationships
      attribute :top_level_links, JSONAPI::Types::Links
      attribute :top_level_meta, JSONAPI::Types::Meta
      attribute :response_errors, JSONAPI::Types::Array(JSONAPI::Types::Error)
      attribute :persisted, Types::Bool.default(false)

      class << self
        def collection_uri
          URI.join(base_uri, collection_path).to_s
        end

        def individual_uri(id)
          URI.join(base_uri, individual_path(id)).to_s
        end

        def related_resource_uri(id, relationship_name)
          URI.join(base_uri, related_resource_path(id, relationship_name)).to_s
        end

        def collection_path
          "/#{type}"
        end

        def individual_path(id)
          "#{collection_path}/#{id}"
        end

        def related_resource_path(id, relationship_name)
          "#{individual_path(id)}/#{relationship_name}"
        end

        def relationship_to_one(name, class_name:)
          klass = Object.const_get(class_name)
          attribute(name, klass)
          define_fetch_relationship_method(name, klass, :fetch_related_resource)
          store_relationship(name)
        end

        def relationship_to_many(name, class_name:)
          klass = Object.const_get(class_name)
          attribute(name, JSONAPI::Types::Array(klass).default([]))
          define_fetch_relationship_method(name, klass, :fetch_related_collection)
          store_relationship(name)
        end

        def store_relationship(name)
          relationship_names(relationship_names + [name])
        end

        def define_fetch_relationship_method(name, klass, fetch_method)
          define_method("fetch_#{name}") do |query = {}|
            send(fetch_method, name, klass, query)
          end
        end

        def fetch(uri, query = {})
          parse(JSONAPI::Client.fetch(uri, default_headers, query))
        end

        def fetch_resource(uri, query = {})
          new(fetch(uri, query))
        end

        def fetch_collection(uri, query = {})
          fetch(uri, query).map { |attributes| new(attributes) }
        end

        def parse(document)
          JSONAPI::Resource::Parser.parse(document)
        end

        def resource_attribute_names
          attribute_names.reject do |attribute|
            (JSONAPI::Resource::Base.attribute_names + relationship_names)
              .include?(attribute)
          end
        end

        private

        def raise_exception_when_errors(&block)
          yield(block).tap do |resource|
            if (errors = resource.response_errors)
              raise JSONAPI::Client::UnprocessableEntity, errors
            end
          end
        end
      end

      def collection_uri
        self.class.collection_uri
      end

      def individual_uri
        self.class.individual_uri(id)
      end

      def related_resource_uri(relationship_name)
        self.class.related_resource_uri(id, relationship_name)
      end

      def resource_attributes
        attributes.slice(*self.class.resource_attribute_names)
      end

      def persisted?
        persisted
      end

      def to_relationship
        { data: identifier }
      end

      def identifier
        { id: id, type: self.class.type }
      end

      def to_payload
        { data: data }
      end

      def data
        identifier
          .merge(attributes: payload_attributes)
          .merge(relationships: payload_relationships)
          .compact
      end

      def payload_attributes
        resource_attributes if resource_attributes.any?
      end

      def payload_relationships
        relationships_or_default
          .transform_values { |relationship| relationship.to_hash.slice(:data) }
          .select { |_key, value| value.any? }
          .yield_self { |results| results if results.any? }
      end

      def relationships_or_default
        relationships || {}
      end

      def fetch_related_resource(relationship_name, klass, query = {})
        klass.fetch_resource(related_resource_uri(relationship_name), query)
      end

      def fetch_related_collection(relationship_name, klass, query = {})
        klass.fetch_collection(related_resource_uri(relationship_name), query)
      end
    end
  end
end
