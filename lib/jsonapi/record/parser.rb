# frozen_string_literal: true

module JSONAPI
  module Record
    class Parser
      attr_reader :document

      private_class_method :new

      def self.parse(document)
        new(document).send(:parse)
      end

      private

      def initialize(document)
        @document = document
      end

      def parse
        case document
        when JSONAPI::Types::Info then parse_info_document
        when JSONAPI::Types::Success then parse_success_document
        when JSONAPI::Types::Failure then parse_failure_document
        end
      end

      def parse_info_document
        { top_level_meta: document.meta }
      end

      def parse_success_document
        case document.data
        when Array then parse_resource_collection(document.data)
        when JSONAPI::Types::Resource then parse_resource(document.data)
        when NilClass
          {}
        end
      end

      def parse_failure_document
        { response_errors: document.errors }
      end

      def parse_resource(resource)
        {
          top_level_meta: document.meta,
          top_level_links: document.links,
          **resource.attributes.slice(:id, :relationships, :links, :meta),
          **resource.resource_attributes,
          **parse_relationships(resource.relationships),
          persisted: true
        }.compact
      end

      def parse_resource_collection(collection)
        collection.map { |resource| parse_resource(resource) }
      end

      def parse_relationships(relationships)
        return {} if included_resources.empty? || relationships.nil?

        relationships.each_with_object({}) do |(name, relationship), hash|
          hash[name] = parse_relationship(relationship)
        end
      end

      def parse_relationship(relationship)
        case relationship.data
        when Array
          parse_relationship_to_many(relationship)
        when JSONAPI::Types::ResourceIdentifier
          parse_relationship_to_one(relationship)
        end
      end

      def parse_relationship_to_one(relationship)
        related_resources_for(relationship)
          .first
          .tap { |resource| parse_resource(resource, document) if resource }
      end

      def parse_relationship_to_many(relationship)
        related_resources_for(relationship)
          .map { |resource| parse_resource(resource) }
      end

      def included_resources
        (document.included || [])
      end

      def related_resources_for(relationship)
        included_resources
          .select { |resource| relationship.includes?(resource.identifier) }
      end
    end
  end
end
